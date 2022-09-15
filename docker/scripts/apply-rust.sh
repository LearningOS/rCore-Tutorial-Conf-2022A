#!/bin/bash

set -exuo pipefail

# Source common functions with funky bash, as per: https://stackoverflow.com/a/12694189
DIR="${BASH_SOURCE%/*}"
test -d "$DIR" || DIR=$PWD
# shellcheck source=utils/common.sh
. "$DIR/utils/common.sh"

# tmp space for building
: "${TEMP_DIR:=/tmp}"
: "${CARGO_HOME:=/usr/local/cargo}"
: "${RUSTUP_HOME:=/usr/local/rustup}"

# Rust toolchain
: "${RUST_TOOLCHAIN:=nightly}"

# Not strictly necessary, but it makes the apt operations in
# ../dockerfiles/apply-rust.dockerfile work.
as_root apt update -q

try_nonroot_first mkdir -p "$TEMP_DIR" || chown_dir_to_user "$TEMP_DIR"
# Get rust nightly
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs >"$TEMP_DIR/rustup.sh"

# try_nonroot_first mkdir -p "$CARGO_HOME" || chown_dir_to_user "$CARGO_HOME"
# try_nonroot_first mkdir -p "$RUSTUP_HOME" || chown_dir_to_user "$RUSTUP_HOME"

sh "$TEMP_DIR/rustup.sh" -y --profile minimal --no-modify-path --default-toolchain "$RUST_TOOLCHAIN"
rm "$TEMP_DIR/rustup.sh"

# Update the current shell
# shellcheck disable=SC1090
source "$CARGO_HOME"/env

rustup --version
cargo --version
rustc --version

# Setup targets and components
rustup target add riscv64gc-unknown-none-elf
cargo install cargo-binutils
rustup component add rust-src llvm-tools-preview

# Make sure that all the files are accessible to other users:
try_nonroot_first chmod -R a+w "$CARGO_HOME" "$RUSTUP_HOME"
