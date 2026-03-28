local jdtls = require("jdtls")
local lsp = require("lsp.helpers")
local home = os.getenv("HOME")
local java_home = os.getenv("JAVA25_HOME") or os.getenv("JAVA_HOME") or "/usr/lib/jvm/java-25-temurin"
local java_path = java_home .. "/bin/java"
local jdtls_path = "/usr/share/java/jdtls"
local java_debug_jar = "/usr/share/java-debug/com.microsoft.java.debug.plugin.jar"
local lombok_jar = home .. "/.local/share/lombok/lombok.jar"
local config_dir = home .. "/.local/share/jdtls/config_linux"
local root_dir = require("jdtls.setup").find_root({
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
  ".git",
  "mvnw",
  "gradlew",
}) or lsp.find_root({
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
  ".git",
  "mvnw",
  "gradlew",
})
local workspace_dir = home .. "/.local/share/jdtls-workspace/" .. lsp.project_name(root_dir)

if vim.fn.filereadable(java_path) == 0 then
  error("Java executable not found at " .. java_path)
end

local launcher_jars = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", false, true)
local launcher_jar = launcher_jars[1]
if not launcher_jar or launcher_jar == "" then
  error("JDTLS launcher JAR not found in " .. jdtls_path .. "/plugins/")
end

if vim.fn.filereadable(lombok_jar) == 0 then
  error("Lombok JAR not found at " .. lombok_jar)
end

if vim.fn.filereadable(java_debug_jar) == 0 then
  error("Java Debug JAR not found at " .. java_debug_jar)
end

if vim.fn.filereadable(config_dir .. "/config.ini") == 0 then
  error("JDTLS config not found at " .. config_dir)
end

vim.fn.mkdir(workspace_dir, "p")

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
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    launcher_jar,
    "-configuration",
    config_dir,
    "-data",
    workspace_dir,
  },
  filetypes = { "java" },
  root_dir = root_dir,
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = "JavaSE-25",
            path = "/usr/lib/jvm/java-25-temurin/",
            default = true,
          },
          {
            name = "JavaSE-21",
            path = "/usr/lib/jvm/java-21-temurin/",
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
  on_attach = function(_, bufnr)
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
