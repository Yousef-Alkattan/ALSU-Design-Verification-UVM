# ALSU Verification UVM

This repository contains the complete UVM testbench and design files for verifying an **Arithmetic Logic and Shift Unit (ALSU)** module. Below is a breakdown of each file and its role in the verification architecture.

---

## 🔷 Introduction

This project presents a **Universal Verification Methodology (UVM)** testbench for verifying an **Arithmetic Logic and Shift Unit (ALSU)**.

The ALSU performs a variety of arithmetic, logical, reduction, and shift operations on signed 3-bit operands `A` and `B`, and provides outputs including LEDs and a 6-bit signed result. The design includes control inputs for bypassing, reduction, and operation selection.

Our verification environment ensures comprehensive checking of functional correctness across all operation modes, including corner cases such as resets, bypasses, and serial input handling.

---

## ALSU Input/Output Ports

| **Port**     | **Direction** | **Description**                                                        |
|--------------|---------------|------------------------------------------------------------------------|
| clk          | Input         | Clock signal                                                          |
| rst          | Input         | Synchronous reset                                                     |
| cin          | Input         | Carry-in for arithmetic operations                                    |
| red_op_A     | Input         | Reduction operation enable for operand A                              |
| red_op_B     | Input         | Reduction operation enable for operand B                              |
| bypass_A     | Input         | Bypass operand A                                                      |
| bypass_B     | Input         | Bypass operand B                                                      |
| direction    | Input         | Direction control for shifts                                          |
| serial_in    | Input         | Serial input value for shift operations                               |
| opcode       | Input [2:0]   | Operation selector                                                    |
| A            | Input signed [2:0] | Signed operand A                                                 |
| B            | Input signed [2:0] | Signed operand B                                                 |
| leds         | Output [15:0] | LED indicators that blinks if an invalid case occurs                 |
| out          | Output signed [5:0] | Signed result of the ALSU operation                              |

---

## 📁 File Descriptions

### 1. Project Reports

- `Yousef_Alkattan_Project2_sv7....`:  
  Includes all codes & Simulation Waveforms

---

### 2. Design Files

- `ALSU.v`  
  RTL design of the ALSU module under test.

---

### 3. UVM Testbench Files

#### 🧱 Testbench Components

- `alsu_if.sv`  
  Defines the interface between testbench and DUT, encapsulating all input/output signals.

- `alsu_agent.sv`  
  UVM agent containing driver, monitor, and sequencer for ALSU transactions.

- `alsu_driver.sv`  
  Drives stimulus to the DUT according to sequence items.

- `alsu_monitor.sv`  
  Observes DUT signals and collects transaction information for checking.

- `alsu_scoreboard.sv`  
  Compares actual DUT outputs with expected results for self-checking.

- `alsu_config.sv`  
  Configuration class for passing handles and parameters.

- `alsu_env.sv`  
  UVM environment that instantiates and connects the agent, scoreboard, and coverage.

- `alsu_test.sv`  
  Top-level UVM test class that starts simulation.

- `alsu_coverage.sv`  
  Functional coverage groups to track verification completeness.

#### Sequences

- `alsu_sequence_item.sv`  
  Defines the transaction structure for ALSU stimulus.

- `alsu_sequence.sv`  
  Main sequence generating operation stimulus.

- `alsu_reset_sequence.sv`  
  Sequence that resets the ALSU before main test stimulus.

- `alsu_sequencer.sv`  
  UVM sequencer controlling the transaction flow.

---

### 4. Assertions

- `alsu_assertions.sv`  
  SystemVerilog assertions for protocol and data property checking.

---

### 5. Do file & File List

- `alsu_files.list`  
  List of all RTL and testbench files for compilation.

- `do_alsu.do`  
  ModelSim/Questa `.do` script for compiling and running the simulation.

---

## 🛠 Tools

- **Language:** SystemVerilog
- **Methodology:** UVM (Universal Verification Methodology)
- **Simulator:** Questasim / ModelSim

---

### Conclusion

This project demonstrates a complete UVM-based verification environment for an Arithmetic Logic and Shift Unit (ALSU). The verification testbench applies constrained random stimulus, functional coverage, and self-checking mechanisms to validate all supported operations, including arithmetic, logic, shift, and rotate functions. Using SystemVerilog and UVM methodology, the environment is modular and reusable, allowing easy extension to additional opcodes or configurations. The approach ensures thorough verification, detects corner-case scenarios, and increases confidence in the ALSU design correctness.


