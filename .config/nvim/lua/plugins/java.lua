return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mfussenegger/nvim-jdtls",
	},
	opts = {
		-- LSP Server Settings
		--- @type lspconfig.options
		setup = {
			jdtls = function(_, opts)
				-- calculate workspace dir
				local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
				local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name
				os.execute("mkdir " .. workspace_dir)
				local jdtls = require("jdtls")

				-- get the mason install path
				local mason_registry = require("mason-registry")
				local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
				local java_test_install_path = require("mason-registry").get_package("java-test"):get_install_path()

				-- get the current OS
				local os
				if vim.fn.has("mac") == 1 then
					os = "mac"
				elseif vim.fn.has("unix") == 1 then
					os = "linux"
				elseif vim.fn.has("win32") == 1 then
					os = "win"
				end

				local bundles = {
					mason_registry.get_package("java-debug-adapter"):get_install_path()
						.. "/extension/server/com.microsoft.java.debug.plugin-0.45.0.jar",
				}
				vim.list_extend(
					bundles,
					vim.split(
						vim.fn.glob(
							mason_registry.get_package("java-test"):get_install_path() .. "/extension/server/*.jar"
						),
						"\n"
					)
				)

				-- vim.list_extend(bundles, vim.split(vim.fn.glob("/home/jemag/dev/vscode-java-test/server/*.jar"), "\n"))
				-- ensure that OS is valid
				if not os or os == "" then
					vim.notify("jdtls: Could not detect valid OS", vim.log.levels.ERROR)
				end
				local jdtls_opts = vim.tbl_deep_extend("force", opts, {
					cmd = {
						"java",
						"-Declipse.application=org.eclipse.jdt.ls.core.id1",
						"-Dosgi.bundles.defaultStartLevel=4",
						"-Declipse.product=org.eclipse.jdt.ls.core.product",
						"-Dlog.protocol=true",
						"-Dlog.level=ALL",
						"-javaagent:" .. install_path .. "/lombok.jar",
						"-Xms1g",
						"--add-modules=ALL-SYSTEM",
						"--add-opens",
						"java.base/java.util=ALL-UNNAMED",
						"--add-opens",
						"java.base/java.lang=ALL-UNNAMED",
						"-jar",
						vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
						"-configuration",
						install_path .. "/config_" .. os,
						"-data",
						workspace_dir,
					},
					init_options = {
						bundles = bundles,
					},
					filetypes = { "java" },
				})
				require("lazyvim.plugins.lsp")
				jdtls.start_or_attach(jdtls_opts)
				return true
			end,
		},
	},
}
