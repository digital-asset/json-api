package(default_visibility = ["//:__subpackages__"])

load(
    "@rules_haskell//haskell:c2hs.bzl",
    "c2hs_toolchain",
)
load("//bazel_tools:haskell.bzl", "da_haskell_library")
load("@build_environment//:configuration.bzl", "ghc_version", "mvn_version", "sdk_version")

config_setting(
    name = "profiling_build",
    values = {
        "compilation_mode": "dbg",
    },
)

c2hs_toolchain(
    name = "c2hs-toolchain",
    c2hs = "@stackage-exe//c2hs",
)

#
# Metadata
#

# The VERSION file is inlined in a few builds.
exports_files([
    "NOTICES",
    "LICENSE",
    "CHANGELOG",
    "tsconfig.json",
])

genrule(
    name = "mvn_version_file",
    outs = ["MVN_VERSION"],
    cmd = "echo -n {mvn} > $@".format(mvn = mvn_version),
)

genrule(
    name = "sdk-version-hs",
    srcs = [],
    outs = ["SdkVersion.hs"],
    cmd = """
        cat > $@ <<EOF
module SdkVersion where

import Module (stringToUnitId, UnitId)

sdkVersion :: String
sdkVersion = "{sdk}"

mvnVersion :: String
mvnVersion = "{mvn}"

damlStdlib :: UnitId
damlStdlib = stringToUnitId ("daml-stdlib-" ++ "{ghc}")
EOF
    """.format(
        ghc = ghc_version,
        mvn = mvn_version,
        sdk = sdk_version,
    ),
)

da_haskell_library(
    name = "sdk-version-hs-lib",
    srcs = [":sdk-version-hs"],
    hackage_deps = [
        "base",
        "extra",
        "ghc-lib-parser",
        "split",
    ],
    visibility = ["//visibility:public"],
)

# Buildifier.

load("@com_github_bazelbuild_buildtools//buildifier:def.bzl", "buildifier")

buildifier_excluded_patterns = [
    "./3rdparty/haskell/c2hs-package.bzl",
    "./3rdparty/haskell/network-package.bzl",
    "**/node_modules/*",
]

# Run this to check if BUILD files are well-formatted.
buildifier(
    name = "buildifier",
    exclude_patterns = buildifier_excluded_patterns,
    mode = "check",
)

# Run this to fix the errors in BUILD files.
buildifier(
    name = "buildifier-fix",
    exclude_patterns = buildifier_excluded_patterns,
    mode = "fix",
    verbose = True,
)
