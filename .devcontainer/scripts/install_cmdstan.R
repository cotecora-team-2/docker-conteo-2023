arch <- R.version$arch
if (arch == "aarch64") {
  cmdstanr::install_cmdstan(cores = 2,
    release_url = "https://github.com/stan-dev/cmdstan/releases/download/v2.31.0/cmdstan-2.31.0-linux-arm64.tar.gz") # nolint
} else {
  cmdstanr::install_cmdstan(cores = 2,
    release_url = "https://github.com/stan-dev/cmdstan/releases/download/v2.31.0/cmdstan-2.31.0.tar.gz") # nolint
}