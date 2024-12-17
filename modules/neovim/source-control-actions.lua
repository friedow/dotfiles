function commit(gitmoji)
	local commit_message = vim.fn.input("Commit Message: ", string.format("%s ", gitmoji))
	vim.cmd("Flog -format=%s%d -all -order=date -open-cmd=edit")
	if commit_message == "" then
		vim.cmd.echo("commit aborted")
		return
	end

	local commitSuccess = os.execute(string.format('git commit -m "%s"', commit_message))
	vim.cmd("Flog -format=%s%d -all -order=date -open-cmd=edit")
	if not commitSuccess then
		vim.cmd.echo("commit failed")
		return
	end

	local pushSuccess = os.execute("git push")
	vim.cmd("Flog -format=%s%d -all -order=date -open-cmd=edit")
	if not pushSuccess then
		vim.cmd.echo("push failed")
		return
	end
end

function select_gitmoji()
	local conf = require("telescope.config").values
	local selected_entry

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = {
					{
						"🎨",
						"🎨 Improve structure / format of the code.",
					},
					{
						"⚡️",
						"⚡️ Improve performance.",
					},
					{
						"🔥",
						"🔥 Remove code or files.",
					},
					{
						"🐛",
						"🐛 Fix a bug.",
					},
					{
						"🚑️",
						"🚑️ Critical hotfix.",
					},
					{
						"✨",
						"✨ Introduce new features.",
					},
					{
						"📝",
						"📝 Add or update documentation.",
					},
					{
						"🚀",
						"🚀 Deploy stuff.",
					},
					{
						"💄",
						"💄 Add or update the UI and style files.",
					},
					{
						"🎉",
						"🎉 Begin a project.",
					},
					{
						"✅",
						"✅ Add, update, or pass tests.",
					},
					{
						"🔒️",
						"🔒️ Fix security or privacy issues.",
					},
					{
						"🔐",
						"🔐 Add or update secrets.",
					},
					{
						"🔖",
						"🔖 Release / Version tags.",
					},
					{
						"🚨",
						"🚨 Fix compiler / linter warnings.",
					},
					{
						"🚧",
						"🚧 Work in progress.",
					},
					{
						"💚",
						"💚 Fix CI Build.",
					},
					{
						"⬇️",
						"⬇️ Downgrade dependencies.",
					},
					{
						"⬆️",
						"⬆️ Upgrade dependencies.",
					},
					{
						"📌",
						"📌 Pin dependencies to specific versions.",
					},
					{
						"👷",
						"👷 Add or update CI build system.",
					},
					{
						"📈",
						"📈 Add or update analytics or track code.",
					},
					{
						"♻️",
						"♻️ Refactor code.",
					},
					{
						"➕",
						"➕ Add a dependency.",
					},
					{
						"➖",
						"➖ Remove a dependency.",
					},
					{
						"🔧",
						"🔧 Add or update configuration files.",
					},
					{
						"🔨",
						"🔨 Add or update development scripts.",
					},
					{
						"🌐",
						"🌐 Internationalization and localization.",
					},
					{
						"✏️",
						"✏️ Fix typos.",
					},
					{
						"💩",
						"💩 Write bad code that needs to be improved.",
					},
					{
						"⏪️",
						"⏪️ Revert changes.",
					},
					{
						"🔀",
						"🔀 Merge branches.",
					},
					{
						"📦️",
						"📦️ Add or update compiled files or packages.",
					},
					{
						"👽️",
						"👽️ Update code due to external API changes.",
					},
					{
						"🚚",
						"🚚 Move or rename resources (e.g.): files, paths, routes).",
					},
					{
						"📄",
						"📄 Add or update license.",
					},
					{
						"💥",
						"💥 Introduce breaking changes.",
					},
					{
						"🍱",
						"🍱 Add or update assets.",
					},
					{
						"♿️",
						"♿️ Improve accessibility.",
					},
					{
						"💡",
						"💡 Add or update comments in source code.",
					},
					{
						"🍻",
						"🍻 Write code drunkenly.",
					},
					{
						"💬",
						"💬 Add or update text and literals.",
					},
					{
						"🗃️",
						"🗃️ Perform database related changes.",
					},
					{
						"🔊",
						"🔊 Add or update logs.",
					},
					{
						"🔇",
						"🔇 Remove logs.",
					},
					{
						"👥",
						"👥 Add or update contributor(s).",
					},
					{
						"🚸",
						"🚸 Improve user experience / usability.",
					},
					{
						"🏗️",
						"🏗️ Make architectural changes.",
					},
					{
						"📱",
						"📱 Work on responsive design.",
					},
					{
						"🤡",
						"🤡 Mock things.",
					},
					{
						"🥚",
						"🥚 Add or update an easter egg.",
					},
					{
						"🙈",
						"🙈 Add or update a .gitignore file.",
					},
					{
						"📸",
						"📸 Add or update snapshots.",
					},
					{
						"⚗️",
						"⚗️ Perform experiments.",
					},
					{
						"🔍️",
						"🔍️ Improve SEO.",
					},
					{
						"🏷️",
						"🏷️ Add or update types.",
					},
					{
						"🌱",
						"🌱 Add or update seed files.",
					},
					{
						"🚩",
						"🚩 Add, update, or remove feature flags.",
					},
					{
						"🥅",
						"🥅 Catch errors.",
					},
					{
						"💫",
						"💫 Add or update animations and transitions.",
					},
					{
						"🗑️",
						"🗑️ Deprecate code that needs to be cleaned up.",
					},
					{
						"🛂",
						"🛂 Work on code related to authorization, roles and permissions.",
					},
					{
						"🩹",
						"🩹 Simple fix for a non-critical issue.",
					},
					{
						"🧐",
						"🧐 Data exploration/inspection.",
					},
					{
						"⚰️",
						"⚰️ Remove dead code.",
					},
					{
						"🧪",
						"🧪 Add a failing test.",
					},
					{
						"👔",
						"👔 Add or update business logic.",
					},
					{
						"🩺",
						"🩺 Add or update healthcheck.",
					},
					{
						"🧱",
						"🧱 Infrastructure related changes.",
					},
					{
						"🧑‍💻",
						"🧑‍💻 Improve developer experience.",
					},
					{
						"💸",
						"💸 Add sponsorships or money related infrastructure.",
					},
					{
						"🧵",
						"🧵 Add or update code related to multithreading or concurrency.",
					},
					{
						"🦺",
						"🦺 Add or update code related to validation.",
					},
				},
				entry_maker = function(entry)
					return {
						value = entry[1],
						display = entry[2],
						ordinal = entry[2],
					}
				end,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				require("telescope.actions").select_default:replace(function()
					require("telescope.actions").close(prompt_bufnr)
					local selected_entry = require("telescope.actions.state").get_selected_entry()
					commit(selected_entry.value)
				end)
				return true
			end,
		})
		:find()
end

select_gitmoji()
