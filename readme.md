
# Table of Contents

1.  [Overview](#org4480b76)
2.  [Structure](#orgabb4e7a)
3.  [Flake outputs](#org6f64271)
        1.  [Scripts](#org9cfe597)
        2.  [Dev shells](#org87bc549)
        3.  [Packages](#org9be3e5b)
4.  [Crates](#org45ab0ce)
    1.  [`AT32F403ACGU7_experiment`](#orgf7799ec)
5.  [Chips](#org1520a86)
    1.  [Main characteristics](#org29b0700)
    2.  [Secondary characteristics](#org7f8be18)
    3.  [Specific traits](#org0450299)
        1.  [Artery AT32F403A](#orgcac93b5)
        2.  [STMicroelectronics STM32F411xC/xE](#org07dd630)
        3.  [Raspberry Pi RP2040](#org4adf3ea)
        4.  [Espressif ESP32-C3FH4](#orgcce9eec)
        5.  [WCH CH592F](#orgf5325c4)
6.  [Boards](#orgc53192b)
    1.  [WeAct BlackPill STM32 v3.0](#org73aed21)
    2.  [WeAct BlackPill AT32 v1.0](#orgfd177fd)
    3.  [WeAct CH592F](#orgcc9ac06)
    4.  [WeAct RP2040](#orgb1d2483)
    5.  [WeAct ESP32-C3FH4](#org07f0c54)
7.  [Documentation](#orga31f3bf)
    1.  [Artery](#org3222214)
        1.  [AT32F403A Series resources](#org575e46b)
    2.  [STMicroelectronics](#org87c128e)
        1.  [ST32F411xC/E Datasheet](#org602d513)
        2.  [STM32F411xC/E Reference manual](#orga4d1ef4)
        3.  [STM32F411xC/E Erratas](#orgbb0b356)
        4.  [STM32 Cortex-M4F Programming manual](#orgb3636a0)
    3.  [Raspberry Pi](#org7b8e0ad)
        1.  [RP2040 Datasheet](#org6677e27)
    4.  [Espressif](#org0ac45a3)
        1.  [ESP32-C3 Datasheet](#orge216f06)
        2.  [ESP32-C3 Technical reference manual](#org08dcd83)
        3.  [ESP32-C3 Erratas](#org1d0f5aa)
        4.  [ESP-IDF Programming guide](#org5893c02)
    5.  [WCH](#orgf4fe137)
        1.  [CH592F Datasheet download page](#orgb986793)
        2.  [CH592F Datasheet](#orgafaf432)
        3.  [QingKeV4 Processor Manual download page](#org661dfa9)
        4.  [QingKeV4 Processor Manual](#orge2a795a)
8.  [Tools](#org066c185)
    1.  [OpenOCD](#orgec9433d)
    2.  [GDB](#orga98a09b)
        1.  [Using GDB with debug probe](#orgbe2d0f6)
    3.  [Black Magic](#orgd1a962b)
        1.  [Conversion of BlackPill into a BMP](#orgdb3e641)
    4.  [probe-rs](#org3220f80)
    5.  [dfu-util](#orgdc2422b)
    6.  [Nix](#org6fa0f48)
        1.  [Usage](#orgbcf8176)
        2.  [Details important for writing a flake](#orgb46184d)
        3.  [Misc](#org6af0674)
    7.  [Cargo](#orge8363ef)
9.  [Note inbox](#org38a257a)
10. [Tasks](#org6535865)
    1.  [OpenOCD fork](#org7e1bfb9)
        1.  [Attempt](#org5095d29)


<a id="org4480b76"></a>

# Overview

This repo is intended for researching embedded rust - development environment, runtime creation, etc.
It includes various information about the tools, MCUs and more, and a short summary of nix commands to help with learning how nix can be used for environment management.


<a id="orgabb4e7a"></a>

# Structure

-   This file is the repo&rsquo;s infodump and todo list.
    -   It is written in org-mode and exported to markdown.
-   `lib/` - in the future, library crates will go here.
-   `<crate_name>` - crate that produces a program.
-   `flake.nix` - defines development environment, packages (built with `nix build .#name`), and more (in the future).


<a id="org6f64271"></a>

# Flake outputs


<a id="org9cfe597"></a>

### Scripts

-   `bmp_gdb [path] [args]...` - conect GDB to Black Magic Probe and do a SWD scan.
-   `openocd-<name> [args]...` - connect to the chip via openocd
-   `probe-rs-<name> <command> [args]...` - run probe-rs command with `--chip <chip_name>` given automatically


<a id="org87bc549"></a>

### Dev shells

-   `default` - everything


<a id="org9be3e5b"></a>

### Packages

Refer to [Crates](#org45ab0ce)


<a id="org45ab0ce"></a>

# Crates


<a id="orgf7799ec"></a>

## `AT32F403ACGU7_experiment`

-   Study of runtime creation on the aforementioned chip.
-   Test crate for developing flake&rsquo;s features.


<a id="org1520a86"></a>

# Chips


<a id="org29b0700"></a>

## Main characteristics

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />

<col  class="org-right" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">Chip</th>
<th scope="col" class="org-left">Core(s)</th>
<th scope="col" class="org-left">Freq.</th>
<th scope="col" class="org-left">SRAM</th>
<th scope="col" class="org-left">ROM/Flash</th>
<th scope="col" class="org-left">Interfaces</th>
<th scope="col" class="org-right">Timers</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left">AT32F403ACGU7</td>
<td class="org-left">Cortex M4F</td>
<td class="org-left">240MHz</td>
<td class="org-left">224K</td>
<td class="org-left">1M</td>
<td class="org-left">3 I2C, 8 USART, 4 SPI, 2 CAN, 2 SD</td>
<td class="org-right">17</td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">STM32F411CEU6</td>
<td class="org-left">Cortex M4F</td>
<td class="org-left">100MHz</td>
<td class="org-left">512K</td>
<td class="org-left">128K</td>
<td class="org-left">3 I2C, 3 USART, 5 SPI, 1 SD</td>
<td class="org-right">11</td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">RP2040</td>
<td class="org-left">2x Cortex M0+</td>
<td class="org-left">133+MHz</td>
<td class="org-left">264K</td>
<td class="org-left">2M-16M</td>
<td class="org-left">2 I2C, 2 UART, 2 SPI, PIO</td>
<td class="org-right">5+</td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">ESP32-C3FH4</td>
<td class="org-left">RV32IMC</td>
<td class="org-left">160MHz</td>
<td class="org-left">400K</td>
<td class="org-left">384K/4MB</td>
<td class="org-left">1 I2C, 2 UART, 3 SPI, 1 I2S, 1 RMT, BLE, WiFi</td>
<td class="org-right">2</td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">CH592F</td>
<td class="org-left">RV32IMAC</td>
<td class="org-left">80MHz</td>
<td class="org-left">26K</td>
<td class="org-left">512K total</td>
<td class="org-left">1 I2C, 4 UART, 1 SPI, BLE</td>
<td class="org-right">4</td>
</tr>
</tbody>
</table>


<a id="org7f8be18"></a>

## Secondary characteristics

-   TODO: properly count PWM channels on at32 and stm32
-   Low power draw - typical current drawn while in the deepest sleep mode possible (Standby for M4F based chips, for example)
    -   First number - without RTC
    -   Second number - with RTC

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />

<col  class="org-right" />

<col  class="org-right" />

<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">Chip</th>
<th scope="col" class="org-left">Extra boot modes</th>
<th scope="col" class="org-right">PWM</th>
<th scope="col" class="org-right">DMA</th>
<th scope="col" class="org-left">MPU</th>
<th scope="col" class="org-left">RTC backed memory</th>
<th scope="col" class="org-left">Low power draw</th>
<th scope="col" class="org-left">USB endpoints</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left">AT32F403ACGU7</td>
<td class="org-left">Flash bank 2</td>
<td class="org-right">13</td>
<td class="org-right">14</td>
<td class="org-left">8*8</td>
<td class="org-left">84 bytes</td>
<td class="org-left">3.9 uA / 4.6 uA</td>
<td class="org-left">8 bi</td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">STM32F411CEU6</td>
<td class="org-left">None</td>
<td class="org-right">22?</td>
<td class="org-right">16</td>
<td class="org-left">8*8</td>
<td class="org-left">80 bytes</td>
<td class="org-left">1.8 uA / 2.4 uA ⁋</td>
<td class="org-left">1 bi, 3 IN, 3 OUT</td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">RP2040</td>
<td class="org-left">SPI</td>
<td class="org-right">16</td>
<td class="org-right">12</td>
<td class="org-left">8*8 †</td>
<td class="org-left">None?</td>
<td class="org-left">180 uA / 181 uA §</td>
<td class="org-left">16 bi</td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">ESP32-C3FH4</td>
<td class="org-left">None</td>
<td class="org-right">6</td>
<td class="org-right">3/3</td>
<td class="org-left">None</td>
<td class="org-left">8K SRAM + 32 bytes</td>
<td class="org-left">1 uA / 5 uA</td>
<td class="org-left">3 IN, 2 OUT</td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">CH592F</td>
<td class="org-left">None</td>
<td class="org-right">12?</td>
<td class="org-right">&#xa0;</td>
<td class="org-left">None</td>
<td class="org-left">2K SRAM + 24K SRAM</td>
<td class="org-left">0.8 uA / 7.3 uA ♂</td>
<td class="org-left">8 bi</td>
</tr>
</tbody>
</table>

-   † - subregions are equal in size
-   ⁋ - Subtract 1.2 uA if power-down reset is disabled (per datasheet)
-   § - RTC is assumed to be consuming 1.1 uA
-   ♂︎ - Numbers given for sleep mode, lowest and highest possible configurations
    -   Shutdown mode (reset on wakeup) consumes 0.4 uA / 1 uA


<a id="org0450299"></a>

## Specific traits


<a id="orgcac93b5"></a>

### Artery AT32F403A

-   SRAM is split into 96K and 128K (according to datasheet)
    -   Seems to be insignificant, as they are placed right next to each other in the memory map.
-   Flash memory is split into two 512K banks, the chip can be configured to boot from either of them.
    -   They are placed right next to each other in the memory map, so they can be treated as one.
-   Configurable code/data readout protection (sLib)
    -   Code and data sections are separate
    -   Configurable region size
    -   When active, protected regions are unaffected by mass erase
    -   Deactivation is passcode protected (which is configured during activation)
    -   Deactivation necessarily does mass erase, including on previously protected regions.
-   TODO: research external memory controller (XMC)
-   CRC


<a id="org07dd630"></a>

### STMicroelectronics STM32F411xC/xE

-   Readout protection
    1.  Level 1 allows downgrading to level 0 (triggering mass erase) and forbids read/write over serial
        -   Insecure, has two methods of attacking, resulting in dumping the entire flash.
    2.  Level 2 disables bootloader and debugging; only the chip&rsquo;s program can make changes to it; **irreversible**
        -   Attack requires flipping bits in the flash, which requires destroying chip&rsquo;s top.
-   CRC


<a id="org4adf3ea"></a>

### Raspberry Pi RP2040

-   UF2 loader allows drag-n-drop flashing
-   Alongside with UF2 loader, PICOBOOT interface is also available
-   Can eke out 20K more SRAM if not using XIP caching and USB
-   Can be overclocked to more than 240MHz and overvolted to 1.3V
-   Has unique Programmable IO (PIO) peripheral, which is essentially a hardware for bit-banging at high speeds
    -   Example: [Bit banged DVI](https://github.com/Wren6991/PicoDVI), [Bit banged Ethernet](https://github.com/kingyoPiyo/Pico-10BASE-T)
-   Bus performance counters for profiling
-   Debug access provides access to one of the cores or Rescue debug port
    -   Can be seen with `swdp_scan`
    -   Useful when cores cannot be used (due to halted system clock).
    -   Rescue DP hard resets the chip and sets a flag about rescue reset, which bootrom checks for, clears and halts the cores.
-   Resus mechanism can recover the controller from halted system clock.
-   Bit banding for peripherals&rsquo; registers
-   Single-cycle IO (SIO) is connected to both processors and provides 1 cycle access to included peripherals at the cost of not having bit banding.
    Included:
    1.  CPUID (unique to each core)
    2.  FIFO lines between cores (two for both directions)
    3.  32 hardware spinlocks (shared between cores)
    4.  GPIO (shared)
    5.  Interpolators (can be used to compute some functions)
        -   Can also  🐸 lerp 🐸
        -   Can also clamp
-   8 cycle integer divider (will need to support separately)
-   Writes to memory-mapped IO registers are always 32 bit sized, if data being written to it is smaller than required it will be duplicated to fill the space.
-   DMA operates faster than processors, doing reads and writes simualteniously
    -   TODO: check if this is the case for other controllers, datasheets for them does not explicitly state this.
-   DMA can do CRC for free


<a id="orgcce9eec"></a>

### Espressif ESP32-C3FH4

-   Flash encryption
-   Secure/Insecure environment split
-   4K one-time-write memory (eFuse)
    -   but only 1792 bits available?
-   8K of RTC-powered memory
-   Remote control (infrared)
-   TWAI (meant for automotive)
-   Hardware acceleration of SHA/RSA/AES/etc.


<a id="orgf5325c4"></a>

### WCH CH592F

-   Flash is divived as such:
    1.  448K General
    2.  32K Data
    3.  24K Bootloader
    4.  8K Info
-   Can run at clock as low as 32KHz
-   RAM is split into 2K and 24K, which are powered separately.
    It is therefore possible to disable 24K RAM to conserve power
-   Capacitive touch input support
-   Hardware acceleration for AES


<a id="orgc53192b"></a>

# Boards


<a id="org73aed21"></a>

## WeAct BlackPill STM32 v3.0

-   [AliExpress](https://aliexpress.ru/item/1005001456186625.html)
-   8MHz XTAL version is preferred
-   On 25MHz XTAL BlackPill&rsquo;s revision, it needs to be heated up for dfu to work properly
-   There may be difference between RST+BOOT0 and holding BOOT0 while attaching USB cable
    [Source](https://www.stm32duino.com/viewtopic.php?t=1234&start=20)


<a id="orgfd177fd"></a>

## WeAct BlackPill AT32 v1.0

-   [AliExpress](https://aliexpress.ru/item/1005004842376803.html)


<a id="orgcc9ac06"></a>

## WeAct CH592F

-   [AliExpress](https://aliexpress.ru/item/1005006117859297.html)


<a id="orgb1d2483"></a>

## WeAct RP2040

-   [AliExpress](https://aliexpress.ru/item/1005003708090298.html)


<a id="org07f0c54"></a>

## WeAct ESP32-C3FH4

-   [AliExpress](https://aliexpress.ru/item/1005004960064227.html)


<a id="orga31f3bf"></a>

# Documentation


<a id="org3222214"></a>

## Artery


<a id="org575e46b"></a>

### [AT32F403A Series resources](https://www.arterychip.com/en/product/AT32F403A.jsp#Resource)

1.  [AT32F403A Datasheet](https://www.arterychip.com/download/DS/DS_AT32F403A_V2.04_EN.pdf)

2.  [AT32F403A/407 Reference manual](https://www.arterychip.com/download/RM/RM_AT32F403A_407_EN_V2.05.pdf)

3.  [AT32F403A/407 Erratas](https://www.arterychip.com/download/Errata/ES0002_AT32F403A_407_Errata_Sheet_EN_V2.0.10.pdf)

4.  [AT32F403A/407 sLib Application note](https://www.arterychip.com/download/APNOTE/AN0040_AT32F403A_407_Security_Library_Application_Note_EN_V2.0.2.pdf)


<a id="org87c128e"></a>

## STMicroelectronics


<a id="org602d513"></a>

### [ST32F411xC/E Datasheet](https://www.st.com/resource/en/datasheet/stm32f411ce.pdf)


<a id="orga4d1ef4"></a>

### [STM32F411xC/E Reference manual](https://www.st.com/resource/en/reference_manual/DM00119316-.pdf)


<a id="orgbb0b356"></a>

### [STM32F411xC/E Erratas](https://www.st.com/resource/en/errata_sheet/dm00137034-stm32f411xc-and-stm32f411xe-device-limitations-stmicroelectronics.pdf)


<a id="orgb3636a0"></a>

### [STM32 Cortex-M4F Programming manual](https://www.st.com/resource/en/programming_manual/pm0214-stm32-cortexm4-mcus-and-mpus-programming-manual-stmicroelectronics.pdf)


<a id="org7b8e0ad"></a>

## Raspberry Pi


<a id="org6677e27"></a>

### [RP2040 Datasheet](https://datasheets.raspberrypi.com/rp2040/rp2040-datasheet.pdf)

Also doubles as a reference manual and includes erratas


<a id="org0ac45a3"></a>

## Espressif


<a id="orge216f06"></a>

### [ESP32-C3 Datasheet](https://www.espressif.com/sites/default/files/documentation/esp32-c3_datasheet_en.pdf)


<a id="org08dcd83"></a>

### [ESP32-C3 Technical reference manual](https://www.espressif.com/sites/default/files/documentation/esp32-c3_technical_reference_manual_en.pdf#usbserialjtag)


<a id="org1d0f5aa"></a>

### [ESP32-C3 Erratas](https://www.espressif.com/sites/default/files/documentation/esp32-c3_errata_en.pdf)


<a id="org5893c02"></a>

### [ESP-IDF Programming guide](https://docs.espressif.com/projects/esp-idf/en/latest/esp32c3/index.html)


<a id="orgf4fe137"></a>

## WCH


<a id="orgb986793"></a>

### [CH592F Datasheet download page](https://www.wch-ic.com/downloads/CH592DS1_PDF.html)


<a id="orgafaf432"></a>

### [CH592F Datasheet](https://www.wch-ic.com/downloads/file/378.html?time=2024-02-05%2021:32:50&code=27Y2KDfBV1Z4gWLChDwF2hbUxEY0bipqRGwSeo7J)


<a id="org661dfa9"></a>

### [QingKeV4 Processor Manual download page](https://www.wch-ic.com/downloads/QingKeV4_Processor_Manual_PDF.html)


<a id="orge2a795a"></a>

### [QingKeV4 Processor Manual](https://www.wch-ic.com/downloads/file/367.html?time=2024-02-05%2021:34:27&code=Nq7FLVBIzX6QixNOBW3QoCdHCefG0peN4hij9kdI)


<a id="org066c185"></a>

# Tools


<a id="orgec9433d"></a>

## OpenOCD

-   Original version does not explicitly support at32 chips
    -   It can work with at32f403acgu7 with this command:
        
            openocd -c "set CPUTAPID 0x2ba01477" -f interface/stlink.cfg -c "transport select hla_swd" -f target/stm32f1x.cfg
        
        However, it may not work in full; for example, it reports that the chip has one flash bank of size 0.
-   There is [arterytek&rsquo;s fork](https://github.com/ArteryTek/openocd) that adds at32 support
-   There is [this fork](https://github.com/Encryptize/openocd-at3) but I haven&rsquo;t tried it properly


<a id="orga98a09b"></a>

## GDB

-   Can be used in scripts to automate flashing/dumping/etc.


<a id="orgbe2d0f6"></a>

### Using GDB with debug probe

[Commands](https://black-magic.org/usage/gdb-commands.html) from Black Magic&rsquo;s site

1.  Attach the microcontroller to the probe and connect the probe to the computer
2.  Launch GDB
3.  Run `target extended-remote /dev/ttyACM0` to attach to the probe
4.  Run `monitor swdp_scan` to scan the microcontroller for the targets to attach to
5.  Run `attach <number>` to attach to one of the targets


<a id="orgd1a962b"></a>

## Black Magic

-   [Source](https://github.com/blackmagic-debug/blackmagic)
-   Black Magic Probe can be bought or created by flashing a firmware on a supported microcontroller
    -   Includes on-probe GDB
    -   STM32F411 may have insufficient capabilities to support all features, check github issues
-   Can be used as a standalone (hosted), currently not investigated
    -   Package is named `blackmagic`


<a id="orgdb3e641"></a>

### Conversion of BlackPill into a BMP

-   What to watch out for:
    1.  There is no `blackpill-f4x1cx.ini`, it was replaced with other files
    2.  Provided shell.nix could be updated
        1.  Add meson and ninja
        2.  Replace nixpkgs download with `import <nixpkgs>`, which will use system nixkpgs
-   Process:
    1.  Built image from the source, it did not work
    2.  Downloaded a `.zip` file mentioned [here](https://github.com/blackmagic-debug/blackmagic/issues/1454), which had prebuilt images
        This worked! It is detected properly now


<a id="org3220f80"></a>

## probe-rs

-   Relies on other probes (STlink/JLink/CMSIS-DAP)
-   STLink probe does not work with RP2040, [as it does not support multidrop swd](https://electronics.stackexchange.com/questions/592979/programming-rp2040-with-st-link)


<a id="orgdc2422b"></a>

## TODO dfu-util

-   STM32 is fully supported.
-   I can dump AT32 but not flash: `Only DfuSe file version 1.1a is supported`
    TODO: research how to resolve the issue
-   RP2040 does not support DFU.
-   ESP32-C3 does not support DFU.
-   CH592F does not seem to support DFU.


<a id="org6fa0f48"></a>

## Nix


<a id="orgbcf8176"></a>

### Usage

-   direnv - tool used to automatically enter and leave the dev environment.
    -   if cargo behaves as if target was not installed, the developer should reenter the env.
        1.  `direnv reload` if using default shell
        2.  Exit and enter the shell
-   `nix flake show` - shows what packages, dev. environments and scripts (apps) are defined
-   `nix flake update` - updates the lockfile
-   `nix build .\#<name>` - builds the package and creates a `result` symlink
-   `nix run .\#<name> -- [args]...` - runs a script (app)
-   `nix develop` - enters development environment (add `.\#<name>` to select non-default)
-   flake.nix, `devShells.default` - defines default development evironment, `nativeBuildInputs` contains the list of installed packages - it is possible to disable those that will not be used.


<a id="orgb46184d"></a>

### Details important for writing a flake

-   At the time of writing, `apps."<name>".program` must be a path.
-   nixpkgs has `systemCross` option meant for cross compiling. It is not used here, as it is not needed and it can lead to confusing outcomes, such as attempting to download gcc version that would run on the microcontroller.
-   `doCheck` has to be false for derivatoins because embedded rust cannot be properly tested without a microcontroller.
-   Source clearing was made to use crane&rsquo;s filter together with a filter for linker scripts.


<a id="org6af0674"></a>

### Misc

-   `rust-overlay` is used to get the toolchain from the file
-   `crane` is used to build packages.


<a id="orge8363ef"></a>

## Cargo

-   Cross-compilation requires:
    1.  A toolchain which can compile to the required target
        -   This can be done with `rust-toolchain.toml`
    2.  Instructing cargo to compile for the target
        1.  There is a CLI option
        2.  `.cargo/config.toml` can be created for this
            -   This will be ignored if `cargo build` is ran from workspace directory.
        3.  `forced-target` can be added to `Cargo.toml`
    3.  Linker requires a linker script.
        -   `build.rs` is required to copy the linker script to the compilation environment
        -   The script itself is required too.


<a id="org38a257a"></a>

# Note inbox

Unsorted notes go here.

-   All available peripherals should be described in a separate section
-   Chips can be very interesting, and only talking about their peripherals might not be enough.
    Prime example: rp2040 seems to be made for pure bandwidth - PIO can be pushed to 300+ Mbps, bus fabric allows great paralellisation, striped SRAM, etc.


<a id="org6535865"></a>

# Tasks


<a id="org7e1bfb9"></a>

## CANCEL OpenOCD fork

-   TODO: properly include arterytek&rsquo;s openocd fork into the env **as an extra that is disabled by default**
    This will let me debug AT32 using that, if I want it


<a id="org5095d29"></a>

### Attempt

-   Added `openocd-artery` and added running it as an app.
    -   It overrides the original&rsquo;s source and version.
    -   I appreciate that making nix build something can be done by the lightest sneeze as long as it includes `${<derivation name>}`
    -   Because the fork is too old, it will require proper packaging, which I don&rsquo;t want to do.

