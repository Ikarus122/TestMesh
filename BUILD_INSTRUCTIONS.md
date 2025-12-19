# RAK3112 Firmware Build Instructions

## Overview
This repository contains the Meshtastic firmware with RAK3112 support from PR #8591. The RAK3112 is a modular variant of the RAK3312 board (ESP32-S3 + SX1262 LoRa radio).

## Configuration
The RAK3112 build environment is configured in `variants/esp32s3/rak3312/platformio.ini`:

```ini
[env:rak3112]
extends = esp32s3_base
board = wiscore_rak3312
board_level = pr
board_check = true
upload_protocol = esptool

build_flags =
  ${esp32_base.build_flags}
  -D RAK3312 
  -D _VARIANT_RAK3112_
  -I variants/esp32s3/rak3312
```

## Build Requirements
- PlatformIO Core 6.1.18 or later
- Internet access to `registry.platformio.org` for downloading build tools
- ESP32 toolchain (will be downloaded automatically by PlatformIO)

## Build Command
```bash
pio run -e rak3112
```

## Output Files
After successful build, the firmware files will be in `.pio/build/rak3112/`:
- `firmware-rak3112-*.bin` - OTA update file
- `firmware-rak3112-*.factory.bin` - Factory flash file (includes bootloader and partitions)
- `firmware-rak3112-*.elf` - Debug symbols file

## Known Issues
### Network Access Required
The build process requires access to:
1. `registry.platformio.org` - For PlatformIO packages
2. `github.com` - For library dependencies
3. `dl.espressif.com` - For ESP32 SDK components

If these domains are blocked, the build will fail with `HTTPClientError`.

### Alternative Build Methods
If direct PlatformIO build fails due to network restrictions:

#### Option 1: Use GitHub Actions
The repository includes GitHub Actions workflows for building firmware. You can:
1. Fork the repository
2. Push your changes
3. Manually trigger the "Build One Target" workflow with target `rak3112` and arch `esp32s3`

#### Option 2: Docker Build
```bash
docker run --rm -v $(pwd):/workspace -w /workspace \
  python:3.14-slim bash -c \
  "pip install platformio && pio run -e rak3112"
```

#### Option 3: Pre-configured Build Environment
Use a machine with unrestricted internet access and PlatformIO pre-installed.

## Hardware Specifications
- **MCU**: ESP32-S3-WROOM-1-N16R8
- **Radio**: Semtech SX1262 LoRa transceiver
- **Flash**: 16MB
- **PSRAM**: 8MB
- **Features**:
  - WiFi & Bluetooth LE
  - USB CDC for serial communication
  - GPIO expansion via WisBlock connector
  - Optional SD card support (modular variant)
  - Battery monitoring (ADC multiplier: 2.11)

## Variant Differences
The RAK3112 differs from RAK3312 in the following ways:
- Modular/stamp form factor
- SD card module support via SPI
- Different ADC multiplier (2.11 vs 1.667)
- Additional I2C bus (Wire1) for expansion
- No built-in GPS (external via UART if needed)

## Firmware Features
The RAK3112 firmware includes:
- Meshtastic mesh networking protocol
- LoRa long-range communication
- Position sharing
- Text messaging
- Bluetooth app connectivity
- WiFi configuration and MQTT support

## Support
For issues or questions about RAK3112 support, refer to:
- Original PR: https://github.com/meshtastic/firmware/pull/8591
- Meshtastic documentation: https://meshtastic.org/docs/
