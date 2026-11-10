"""Behaviour check for firefox-no-tabs.

Drives the patched Firefox headless and asserts that every way of opening a
tab produces a new window instead, and that the tab bar is collapsed.
"""

import json
import os
import sys
import tempfile
import time
import zipfile

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.firefox.service import Service

FIREFOX, GECKODRIVER = sys.argv[1], sys.argv[2]

WINDOWS_JS = """
const out = [];
for (const win of Services.wm.getEnumerator("navigator:browser")) {
  out.push(win.gBrowser.tabs.length);
}
return out;
"""


def make_extension(directory):
    """A temporary extension that creates a tab via browser.tabs.create."""
    manifest = {
        "manifest_version": 2,
        "name": "firefox-no-tabs-check",
        "version": "1.0",
        "browser_specific_settings": {"gecko": {"id": "no-tabs-check@test"}},
        "background": {"scripts": ["background.js"]},
    }
    path = os.path.join(directory, "check.xpi")
    with zipfile.ZipFile(path, "w") as xpi:
        xpi.writestr("manifest.json", json.dumps(manifest))
        xpi.writestr(
            "background.js", 'browser.tabs.create({ url: "about:blank" });'
        )
    return path


def main():
    options = Options()
    options.binary_location = FIREFOX
    options.add_argument("-headless")
    # Allow window.open from a script without a user gesture.
    options.set_preference("dom.disable_open_during_load", False)

    # Chrome-context scripting needs system access since Firefox ~138.
    os.environ["MOZ_REMOTE_ALLOW_SYSTEM_ACCESS"] = "1"
    driver = webdriver.Firefox(options=options, service=Service(GECKODRIVER))
    failures = []

    def windows():
        with driver.context(driver.CONTEXT_CHROME):
            return driver.execute_script(WINDOWS_JS)

    def expect(name, action):
        before = windows()
        action()
        deadline = time.monotonic() + 15
        while time.monotonic() < deadline:
            after = windows()
            if len(after) == len(before) + 1 and all(n == 1 for n in after):
                print(f"ok   {name}: {after}")
                return
            time.sleep(0.2)
        failures.append(name)
        print(f"FAIL {name}: before={before} after={windows()}")

    def chrome(script):
        def run():
            with driver.context(driver.CONTEXT_CHROME):
                driver.execute_script(script)

        return run

    try:
        main_handle = driver.current_window_handle

        with driver.context(driver.CONTEXT_CHROME):
            visibility = driver.execute_script(
                'return getComputedStyle(document.getElementById("TabsToolbar")).visibility;'
            )
        if visibility == "collapse":
            print("ok   tab bar collapsed")
        else:
            failures.append("tab bar")
            print(f"FAIL tab bar visibility: {visibility}")

        for button in ("back-button", "forward-button"):
            with driver.context(driver.CONTEXT_CHROME):
                display = driver.execute_script(
                    f'return getComputedStyle(document.getElementById("{button}")).display;'
                )
            if display == "none":
                print(f"ok   {button} hidden")
            else:
                failures.append(button)
                print(f"FAIL {button} display: {display}")

        expect("Ctrl+T (BrowserCommands.openTab)", chrome("BrowserCommands.openTab();"))
        expect(
            'openTrustedLinkIn "tab"',
            chrome('openTrustedLinkIn("about:blank", "tab");'),
        )
        expect(
            'openTrustedLinkIn "tabshifted" (background)',
            chrome('openTrustedLinkIn("about:blank", "tabshifted");'),
        )
        expect(
            "external link (OPEN_NEWTAB)",
            chrome(
                """
                window.browserDOMWindow.openURI(
                  Services.io.newURI("about:blank"),
                  null,
                  Ci.nsIBrowserDOMWindow.OPEN_NEWTAB,
                  Ci.nsIBrowserDOMWindow.OPEN_EXTERNAL,
                  Services.scriptSecurityManager.getSystemPrincipal()
                );
                """
            ),
        )

        driver.switch_to.window(main_handle)
        driver.get(
            'data:text/html,<a id="l" target="_blank" href="about:blank">x</a>'
        )
        expect(
            "target=_blank click",
            lambda: driver.find_element(By.ID, "l").click(),
        )

        driver.switch_to.window(main_handle)
        expect(
            "window.open",
            lambda: driver.execute_script('window.open("about:blank");'),
        )

        expect("open private window", chrome("OpenBrowserWindow({ private: true });"))
        expect(
            "Ctrl+T in a private window",
            chrome(
                """
                BrowserWindowTracker.getTopWindow({ private: true })
                  .BrowserCommands.openTab();
                """
            ),
        )
        with driver.context(driver.CONTEXT_CHROME):
            private = driver.execute_script(
                """
                let n = 0;
                for (const win of Services.wm.getEnumerator("navigator:browser")) {
                  if (PrivateBrowsingUtils.isWindowPrivate(win)) n++;
                }
                return n;
                """
            )
        if private == 2:
            print("ok   new window from a private window is private")
        else:
            failures.append("private window")
            print(f"FAIL private windows: {private}, expected 2")

        with tempfile.TemporaryDirectory() as tmp:
            xpi = make_extension(tmp)
            expect(
                "extension tabs.create",
                lambda: driver.install_addon(xpi, temporary=True),
            )
    finally:
        driver.quit()

    if failures:
        print(f"firefox-no-tabs check failed: {', '.join(failures)}")
        sys.exit(1)
    print("firefox-no-tabs check passed")


main()
