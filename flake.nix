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
    flake-utils.lib.eachDefaultSystem (
      system: let
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

        #Attaches GDB to BMP
        scriptBMP_GDB = pkgs.writeScript "bmp-gdb-attach.sh" ''
          #!/usr/bin/env sh
          #if the first argument is not a path (for example if it is --tui), use default and don't shift
          if [ ! -e "$1" ]; then
            SERIAL_PATH='/dev/ttyACM0'
          else
            SERIAL_PATH=''${1:-'/dev/ttyACM0'}
            shift
          fi

          if [ ! -c "$SERIAL_PATH" ]; then
            echo "error: $SERIAL_PATH does not exist"
            exit 1
          fi
          ${pkgs.gdb}/bin/gdb -ex "target extended-remote $SERIAL_PATH" -ex "monitor swdp_scan" "$@"
        '';

        #Autofills the chip name
        scriptProbeRsFor = shortName: chipName:
        #TODO: mention that the script will not work with the command that do not
        #expect --chip, but these commands are not about the chip anyway, so the user
        #has to use probe-rs directly
          pkgs.writeScript "probe-rs-${chipName}.sh" ''
            #!/usr/bin/env sh
            if [ $# -eq 0 ]; then
              # Call probe-rs for help
              ${pkgs.probe-rs}/bin/probe-rs
              # Exit with the same code
              exit 2
            fi
            COMMAND=$1
            shift
            ${pkgs.probe-rs}/bin/probe-rs $COMMAND --chip ${chipName} "$@"
          '';

        scriptOpenOCDFor = shortName: target: CPUTAPID: interface: transport:
          pkgs.writeScript "openocd-${shortName}.sh" ''
            #!/usr/bin/env sh
            ${pkgs.openocd}/bin/openocd -c "set CPUTAPID ${CPUTAPID}" -f interface/${interface} \
            -c "transport select ${transport}"  -f target/${target} "$@"
          '';

        genScripts = list:
          builtins.foldl' (acc: elem:
            {
              "probe-rs-${elem.shortName}" = {
                type = "app";
                program = "${scriptProbeRsFor elem.shortName elem.chipName}";
              };
              "openocd-${elem.shortName}" = {
                type = "app";
                program = "${scriptOpenOCDFor elem.shortName elem.target elem.cputapid elem.interface elem.transport}";
              };
            }
            // acc) {}
          list;
        #Fork of openocd by arterytek that supports at32
        #TODO: the source is too old for a simple override like this
        openocd-artery = pkgs.openocd.overrideAttrs {
          version = "0.10.0";
          src = pkgs.fetchFromGitHub {
            owner = "ArteryTek";
            repo = "openocd";
            rev = "03c994a730a90ac4056b5f0b4c715e2af2630461";
            sha256 = "sha256-u8x1X0J9hHYlk+l1VwwGd5jJ92t6UWAw7SARL7rpf7M=";
          };
        };
      in {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs;
            [
              cargo-binutils
              gdb
              probe-rs
              #TODO: have a fork be available too?
              openocd
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
        apps =
          {
            bmp_gdb = {
              type = "app";
              program = "${scriptBMP_GDB}";
            };
            # Uses github:arterytek/openocd (fork that adds proper support for at32)
            # TODO: package the fork first
            # openocd-arterytek-at32 = {
            #   type = "app";
            #   program = "${openocd-artery}/bin/openocd";
            # };
          }
          // genScripts [
            {
              shortName = "at32";
              chipName = "at32f403acgu7";
              target = "stm32f1x.cfg";
              interface = "stlink.cfg";
              cputapid = "0x2ba01477";
              transport = "hla_swd";
            }
            #TODO: rp2040 will not work with stlink because stlink cannot do multidrop swd
            #(which is needed because the chip is multicore).
            # {
            #   shortName = "rp2040";
            #   chipName = "rp2040";
            #   target = "";
            #   interface = "";
            #   cputapid = "";
            # }
          ];
      }
    );
}
