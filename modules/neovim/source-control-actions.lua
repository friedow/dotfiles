local commit_message = vim.fn.input("Commit Message: ")
local commitSuccess = os.execute(string.format('git commit -m "%s"', commit_message))
vim.cmd("Flog -format=%s%d -all -order=date -open-cmd=edit")
if ~commitSuccess then
	vim.cmd("echo commit aborted")
	return
end

local pushSuccess = os.execute("git push")
vim.cmd("Flog -format=%s%d -all -order=date -open-cmd=edit")
if ~pushSuccess then
	vim.cmd("echo push failed")
	return
end
