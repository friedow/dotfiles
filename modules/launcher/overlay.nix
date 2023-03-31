self: super: {
  rofi-custom = super.rofi.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "davatorium";
      repo = "rofi";
      rev = "38c102d63b51488299fad4189beb5bbf3e7ca5ae";
      sha256 = "sha256-60yuMp0iteZmDMriBnGk+S0nxhzlnznW+PXckXUjHsw=";
    };
  });
}
