# VHDL Enigma Machine

A hardware implementation of the historical Enigma machine on an Altera Cyclone V FPGA board with VGA display output.

## Overview

This project implements a functional Enigma machine encryption device in VHDL. It simulates the mechanical rotors (gears) and plugboard of a real Enigma machine, allowing users to encode messages in real-time. The encrypted output and machine state are displayed on a VGA monitor connected to the FPGA board.

## Features

- **Three Rotor System**: Implements rotors I, II, and III from the Enigma I machine
- **Reflector**: Uses the UKW (Umkehrwalze) reflector from the German Railway Enigma (Rocket)
- **Plugboard Configuration**: Configurable letter substitution board for enhanced security
- **VGA Display**: Real-time display of:
  - Current input character
  - Plugboard setting
  - Encrypted character output
  - Message history (21 characters)
- **Rotor Position Tracking**: Automatic rotor advancement with proper mechanical stepping
- **Mode Selection**: Three operational modes:
  - **WRITE Mode**: Encrypt messages by selecting input characters
  - **GEARS Mode**: Configure which rotors to use and their positions
  - **PLUGBOARD Mode**: Set up the plugboard substitutions

## Hardware Requirements

- Altera Cyclone V FPGA Board
- VGA Monitor or display (640x480 resolution)
- Input controls (buttons/switches) for:
  - Character/configuration selection
  - Confirm button (active low)
  - Mode selection button (active low)
  - Reset button (active low)

## Project Structure

### Core VHDL Modules

| File | Description |
|------|-------------|
| `EnigmaGears.vhd` | Main encryption engine that processes input through rotors, reflector, and plugboard |
| `GearControl.vhd` | State machine managing user input, mode switching, and rotor/plugboard configuration |
| `my_package.vhd` | Package containing gear definitions, position arrays, and helper functions |
| `font_az_pkg.vhd` | Font definitions for VGA character display (A-Z) |
| `enigma_text_line.vhd` | VGA text rendering module for displaying the character line |
| `vga_timing_640x480.vhd` | VGA signal timing generator for 640x480 resolution |
| `vga_top.vhd` | Top-level VGA display controller |

### Design Files

- `Engima.bdf` - Top-level block diagram
- `GearControl.qpf` / `GearControl.qsf` - Quartus project files
- `GearControl.csv` - Pin assignments and device configuration

## How It Works

### Encryption Process

1. **Plugboard Input**: Input character passes through plugboard substitution
2. **Forward Through Rotors**: Character passes through rotors I, II, III in selected configuration
3. **Reflector**: Character bounces off the reflector (UKW)
4. **Reverse Through Rotors**: Return path through rotors (reverse wiring)
5. **Plugboard Output**: Final character passes through plugboard again

### Rotor Stepping

Each time a character is encrypted:
- Rotor 0 (rightmost) advances by 1 position
- When Rotor 0 reaches position 25, it resets and Rotor 1 advances
- This continues for Rotor 2 when Rotor 1 cycles
- This mechanical stepping is crucial for the Enigma's security

## Usage

### Mode Operations

**WRITE Mode**:
- Press mode button to access
- Input characters using the input controls
- Press confirm button to encrypt and display result
- Up to 21 characters are displayed on screen

**GEARS Mode**:
- Configure which of the three rotors (0, 1, 2, 3) to use in each position
- Rotor 3 is the reflector, so only rotors 0-2 are valid selections
- Default configuration: rotors 0, 1, 2

**PLUGBOARD Mode**:
- Set up character-to-character substitutions (0-25)
- Configure swaps for enhanced encryption security
- Default: no plugboard substitutions

### Controls

- **Mode Button** (active low): Cycles through WRITE → GEARS → PLUGBOARD → WRITE
- **Confirm Button** (active low): Confirms character/rotor/plugboard selection
- **Reset Button** (active low): Resets machine to default state
- **Input (5 bits)**: Selects character (0-25 for A-Z) or configuration value

## Historical Context

The Enigma machine was a German military encryption device used during World War II. This implementation recreates the core mechanical and electrical behavior of the Enigma I variant, including:
- The same rotor wiring and reflector configurations used historically
- The mechanical rotor stepping mechanism
- Plugboard configuration capability

## Technical Details

- **Language**: VHDL
- **Target Device**: Altera Cyclone V
- **Logic Elements**: ~70 LE
- **Input/Output**: 5-bit character encoding (0-25 for A-Z)
- **Display Resolution**: 640x480 VGA
- **Character Set**: A-Z alphabet

## Pin Configuration

Pin assignments and device settings are defined in:
- `GearControl.qsf` - Quartus settings file
- `c5_pin_model_dump.txt` - Cyclone V pin model reference

## Building and Deployment

1. Open `GearControl.qpf` in Altera Quartus Prime
2. Review pin assignments in the pin planner
3. Compile the design
4. Generate programming file (.sof)
5. Program the Cyclone V board
6. Connect VGA display and input controls

## License

No license specified. Please check repository for any licensing information.

## Author

paolowsaliba

---

For more information about the historical Enigma machine, see: https://en.wikipedia.org/wiki/Enigma_machine
