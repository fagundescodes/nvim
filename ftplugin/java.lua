local jdtls = require("jdtls")
local home = os.getenv("HOME")

local java_path = "/usr/lib/jvm/java-21-openjdk/bin/java"
local jdtls_path = "/usr/share/java/jdtls"
local java_debug_jar = "/usr/share/java-debug/com.microsoft.java.debug.plugin.jar"
local lombok_jar = home .. "/.local/share/lombok/lombok.jar"
local workspace_dir = home .. "/.local/share/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

if vim.fn.filereadable(java_path) == 0 then
  error("Java executable not found at " .. java_path)
end

local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher_jar == "" then
  error("JDTLS launcher JAR not found in " .. jdtls_path .. "/plugins/")
end

if vim.fn.filereadable(lombok_jar) == 0 then
  error("Lombok JAR not found at " .. lombok_jar)
end

if vim.fn.filereadable(java_debug_jar) == 0 then
  error("Java Debug JAR not found at " .. java_debug_jar)
end

local config = {
  cmd = {
    java_path,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Dfile.encoding=UTF-8",
    "-XX:+UseParallelGC",
    "-XX:GCTimeRatio=4",
    "-XX:AdaptiveSizePolicyWeight=90",
    "-javaagent:" .. lombok_jar,
    "-jar",
    launcher_jar,
    "-configuration",
    "/usr/share/java/jdtls/config_linux",
    "-data",
    workspace_dir,
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
  },
  filetypes = { "java" },
  root_dir = require("jdtls.setup").find_root({ "pom.xml", "build.gradle", ".git" }) or vim.fn.getcwd(),
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = "JavaSE-21",
            path = "/usr/lib/jvm/java-21-openjdk/",
          },
        },
      },
      format = {
        enabled = true,
      },
      project = {
        referencedLibraries = {
          "lib/**/*.jar",
        },
      },
      maven = {
        downloadSources = true,
        updateSnapshots = true,
      },
      gradle = {
        downloadSources = true,
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
    },
  },
  init_options = {
    bundles = { java_debug_jar },
    workspaceFolders = nil,
  },
  handlers = {
    ["language/status"] = function() end,
  },
  on_attach = function(client, bufnr)
    local utils = require("lsp.utils")
    utils.on_attach(client, bufnr)

    vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, { buffer = bufnr, desc = "Organize imports (Java)" })
    vim.keymap.set("n", "<leader>jev", jdtls.extract_variable, { buffer = bufnr, desc = "Extract variable (Java)" })
    vim.keymap.set("n", "<leader>jec", jdtls.extract_constant, { buffer = bufnr, desc = "Extract constant (Java)" })
    vim.keymap.set("v", "<leader>jem", function()
      jdtls.extract_method(true)
    end, { buffer = bufnr, desc = "Extract method (Java)" })
    vim.keymap.set("n", "<leader>jt", jdtls.test_nearest_method, { buffer = bufnr, desc = "Test nearest method (Java)" })
    vim.keymap.set("n", "<leader>jT", jdtls.test_class, { buffer = bufnr, desc = "Test class (Java)" })
  end,
}

jdtls.start_or_attach(config)
