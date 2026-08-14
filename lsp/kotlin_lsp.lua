-- JetBrains' Kotlin LSP (mason: kotlin-lsp). Handles plain Kotlin and Jetpack
-- Compose alike -- Compose is ordinary Kotlin plus a compiler plugin, so nothing
-- extra is needed here beyond a Gradle root the server can import.
--
-- The mason bin symlink is version-stable, unlike the versioned package dir, and
-- an absolute path avoids depending on mason having prepended its bin dir to PATH
-- (this config is read before mason loads). The bundled kotlin-lsp.sh is
-- deprecated in favour of this binary.
return {
  cmd = {
    vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "intellij-server"),
    "--stdio",
    -- Without this the server defaults to a TCP socket on 127.0.0.1:9999 and
    -- shuts down when the first client disconnects.
    "--system-path",
    vim.fs.joinpath(vim.fn.stdpath("cache"), "kotlin-lsp"),
    "--log-level",
    "ERROR",
  },
  filetypes = { "kotlin" },
  -- Gradle roots first (settings.* marks the actual project root in a multi-module
  -- Android build, so prefer it over a nested module's build.gradle).
  root_markers = {
    "settings.gradle.kts",
    "settings.gradle",
    "build.gradle.kts",
    "build.gradle",
    "pom.xml",
    ".git",
  },
}
