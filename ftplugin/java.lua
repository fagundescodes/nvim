local jdtls = require("jdtls")

local config = {
  name = "jdtls",
  cmd = { "jdtls" },
  root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw" }),
  settings = {
    java = {
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
    bundles = { "/usr/share/java-debug/com.microsoft.java.debug.plugin.jar" },
  },
  on_attach = function(_, bufnr)
    vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, { buf = bufnr, desc = "Organize imports (Java)" })
    vim.keymap.set("n", "<leader>jev", jdtls.extract_variable, { buf = bufnr, desc = "Extract variable (Java)" })
    vim.keymap.set("n", "<leader>jec", jdtls.extract_constant, { buf = bufnr, desc = "Extract constant (Java)" })
    vim.keymap.set("v", "<leader>jem", function()
      jdtls.extract_method(true)
    end, { buf = bufnr, desc = "Extract method (Java)" })
    vim.keymap.set("n", "<leader>jt", jdtls.test_nearest_method, { buf = bufnr, desc = "Test nearest method (Java)" })
    vim.keymap.set("n", "<leader>jT", jdtls.test_class, { buf = bufnr, desc = "Test class (Java)" })
  end,
}

jdtls.start_or_attach(config, { dap = { hotcodereplace = "auto" } })
