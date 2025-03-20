return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		require("dapui").setup()

		require("dap").set_log_level("DEBUG")

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
				args = { "--port", "${port}" },
			},
		}

		dap.adapters.pico = {
			type = "executable",
			command = "arm-none-eabi-gdb",
			args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
		}

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
			-- Pico SWD Debugging with GDB
			{
				name = "Attach to Pico (OpenOCD)",
				type = "pico",
				request = "attach",
				target = "localhost:3333",
				program = function()
					return vim.fn.input("Path to elf: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
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
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpointColor", linehl = "", numhl = "" })

		require("nvim-dap-virtual-text").setup()
	end,
}
