return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		"jedrzejboczar/nvim-dap-cortex-debug",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup()
		dap.set_log_level("TRACE")

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
				args = { "--port", "${port}" },
			},
		}

		-- Setup cortex-debug adapter using nvim-dap-cortex-debug
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

		-- Debug configurations for C
		dap.configurations.c = {
			-- Default: Launch with CodeLLDB
			{
				name = "Launch with CodeLLDB",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
			-- Cortex-debug configuration for OpenOCD
			dap_cortex_debug.openocd_config({
				name = "Debug with OpenOCD",
				cwd = "${workspaceFolder}",
				executable = "${workspaceFolder}/build/blink.elf", -- change to your binary's path
				configFiles = { "interface/cmsis-dap.cfg", "target/rp2040.cfg" }, -- adjust to your OpenOCD config file(s)
				gdbTarget = "localhost:3333", -- set the correct GDB target port if needed
				rttConfig = dap_cortex_debug.rtt_config(0), -- configures the first RTT channel
				showDevDebugOutput = false,
			}),
		}

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

		vim.cmd("hi DapBreakpointColor guifg=#fa4848")
		vim.fn.sign_define("DapBreakpoint", {
			text = "",
			texthl = "DapBreakpointColor",
			linehl = "",
			numhl = "",
		})

		require("nvim-dap-virtual-text").setup()
	end,
}
