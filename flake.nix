{
  # Written with help of https://n8henrie.com/2023/09/compiling-rust-for-the-esp32-with-nix/
  inputs = {
    nixpkgs.url = "github:nixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = input @ {
    nixpkgs,
    rust-overlay,
    flake-utils,
    crane,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [(import rust-overlay)];
      # Not pictured: trying to use crossSystem.
      # crossSystem is not required and, at least for embedded rust projects, serves
      # no purpose.
      pkgs = import nixpkgs {
        inherit system overlays;
      };
      toolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      craneLib = (crane.mkLib pkgs).overrideToolchain toolchain;

      # Filter to not remove linker scripts
      linkerScriptFilter = path: type: let
        baseName = builtins.baseNameOf (toString path);
      in (pkgs.lib.hasSuffix ".x" baseName);
      # All filters (crane's and linker script) combined
      craneFilters = path: type: (linkerScriptFilter path type) || (craneLib.filterCargoSources path type);

      # Generate package along with the apps (scripts) to flash, begin debugging, verify,
      # etc.
      # TODO: GDB should have some protection from flashing a program to an incorrect chip
      # This is possible by also defining the probe name for bmp
      # TODO: on Darwin, serial port will be different
      makeProgram = {
        crateName,
        gdbName,
        directory,
        ...
      }: let
        # Verify that the target microcontroller is reachable and is the expected one
        # TODO: use writeShellApplication instead of writeScript
        gdbVerify = pkgs.writeScript "gdb_verify.sh" ''
          #!/usr/bin/env sh

          # Name of the device being manipulated in 'monitor swdp_scan' output.
          GDB_NAME=$1
          # Path to serial device
          SERIAL_PATH=$\{2:-'/dev/ttyACM0'}

          #Scan first to assert that name in GDB is correct
          #TODO: determine if cutting 8th and 9th fields is ok
          #(and if it is ok to use cut here at all)
          DEVICE_NAME=$(gdb -nx --batch \
              -ex "target extended-remote $SERIAL_PATH" \
              -ex "monitor swdp_scan" 2>&1 | tail -n 1 | cut --delimiter=\  --fields="8,9" | head --bytes=-1)
          if [ "$GDB_NAME" = "$DEVICE_NAME" ];
          then
              exit 0
          else
              echo "Expected swdp_scan to return '$GDB_NAME', got '$DEVICE_NAME'"
              echo $DEVICE_NAME > out
              exit 1
          fi
        '';
        #TODO: scripts to flash firmware (add necessary info to function's inputs),
        #check firmware against file, or simply remain in the session
      in
        #TODO: names are "package_name"-"bmp/probe-rs/etc."-"debug/flash/etc."
        #options for bmp: serial port
        # (probe only connects one device so attach 1 works always)
        {
          # apps."${crateName}-bmp-debug" = {
          #   type = "app";
          #   # program =
          # };
        };
      # Map makeProgram to a list of directory names, join the attrsets, then join
      # it with the attrset containing devshell definition
      # TODO: think about having devshells (and toolchains) for development
      # on different architectures (if the programmer wants to develop, say, only for rp2040 here)
    in {
      #TODO:
      # flashing and debugging setup
      # Can make it as apps.[name], that could be run with nix run
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs;
          [
            # gcc
            cargo-binutils
            gdb
          ]
          ++ [
            toolchain
          ];
      };
      packages.at32_experiment = craneLib.buildPackage {
        src = pkgs.lib.cleanSourceWith {
          src = craneLib.path ./at32f403acgu7_experiment;
          filter = craneFilters;
        };
        cargoLock = ./Cargo.lock;
        #embedded targets cannot be checked automatically
        doCheck = false;
      };
    });
}
