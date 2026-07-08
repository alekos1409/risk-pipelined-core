# risk-pipelined-core
5-stage pipelined RISC-V (RV32I) core implemented in Verilog.

This project implements a 32-bit RISC-V (RV32I) 5-stage pipelined processor in Verilog HDL.
The processor was developed as an educational and architectural project with the goal of understanding modern processor design, pipelining, hazard handling, and memory interfacing.
The implementation follows the classic five-stage RISC pipeline:
Instruction Fetch (IF)
Instruction Decode (ID)
Execute (EX)
Memory Access (MEM)
Write Back (WB)

Features:
RV32I instruction subset
Five-stage pipeline
Pipeline registers between all stages
Hazard Detection Unit
Data Forwarding Unit
ALU Control Unit
Immediate Generator
Register File
Instruction Memory
Data Memory
Branch and Jump support
Fully written in Verilog HDL

Pipeline Overview
The processor uses the standard RISC-V five-stage pipeline:
IF → ID → EX → MEM → WB
Pipeline hazards are handled using:
Data forwarding
Hazard detection
Pipeline stalling when required
