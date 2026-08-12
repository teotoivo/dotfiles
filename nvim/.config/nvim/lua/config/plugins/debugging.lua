return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
		"jedrzejboczar/nvim-dap-cortex-debug",
	},

	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("dap-go").setup()
		require("dapui").setup()

		if not dap.adapters["codelldb"] then
			require("dap").adapters["codelldb"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = {
						"--port",
						"${port}",
					},
				},
			}
		end

		local dap_cortex_debug = require("dap-cortex-debug")
		dap_cortex_debug.setup({
			debug = false, -- enable for verbose logging if needed
			extension_path = vim.fn.stdpath("data") .. "/mason/packages/cortex-debug/extension", -- auto-detect via mason.nvim or set manually to your cortex-debug folder containing dist/debugadapter.js
			lib_extension = nil, -- usually auto-detected ('so' on Unix)
			node_path = "node", -- adjust if node is in a custom location
			dapui_rtt = true, -- integrates RTT output with dap-ui
			dap_vscode_filetypes = { "c", "cpp" },
			rtt = {
				buftype = "Terminal", -- or "BufTerminal" depending on your preference
			},
		})

		for _, lang in ipairs({ "c", "cpp" }) do
			dap.configurations[lang] = {
				{
					type = "codelldb",
					request = "launch",
					name = "Launch file",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
				{
					type = "codelldb",
					request = "attach",
					name = "Attach to process",
					pid = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
				dap_cortex_debug.openocd_config({
					name = "Debug Pico with OpenOCD",
					cwd = "${workspaceFolder}",
					executable = function()
						return vim.fn.input("Path to ELF: ", vim.fn.getcwd() .. "", "file")
					end, -- change to your binary's path
					configFiles = { "interface/cmsis-dap.cfg", "target/rp2040.cfg" }, -- adjust to your OpenOCD config file(s)
					gdbTarget = "localhost:3333", -- set the correct GDB target port if needed
					rttConfig = dap_cortex_debug.rtt_config(0), -- configures the first RTT channel
					showDevDebugOutput = false,
				}),
				dap_cortex_debug.openocd_config({
					name = "Debug Pico 2 with OpenOCD",
					cwd = "${workspaceFolder}",
					executable = function()
						return vim.fn.input("Path to ELF: ", vim.fn.getcwd() .. "", "file")
					end, -- change to your binary's path
					configFiles = { "interface/cmsis-dap.cfg", "target/rp2350.cfg" }, -- adjust to your OpenOCD config file(s)
					gdbTarget = "localhost:3333", -- set the correct GDB target port if needed
					rttConfig = dap_cortex_debug.rtt_config(0), -- configures the first RTT channel
					showDevDebugOutput = false,
				}),
			}
		end

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue", noremap = true, silent = true })
		vim.keymap.set("n", "<F9>", dap.step_over, { desc = "DAP: Step Over", noremap = true, silent = true })
		vim.keymap.set("n", "<F10>", dap.step_into, { desc = "DAP: Step Into", noremap = true, silent = true })
		vim.keymap.set("n", "<F11>", dap.step_out, { desc = "DAP: Step Out", noremap = true, silent = true })
	end,
}
