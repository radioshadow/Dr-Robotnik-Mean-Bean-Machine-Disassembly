@echo off
assembler\asm68k /p /o ae- /o l. main.asm, Dr_Robotnik's_Mean_Bean_Machine.md, , Dr Robotnik's Mean Bean Machine.lst > log.txt
type log.txt
assembler\fixheadr Dr_Robotnik's_Mean_Bean_Machine.md
