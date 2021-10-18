@echo off
compiler\asm68k /p /o ae- /o l. main.asm, Dr_Robotnik's_Mean_Bean_Machine.md, , Dr Robotnik's Mean Bean Machine.lst > log.txt
type log.txt
compiler\fixheadr Dr_Robotnik's_Mean_Bean_Machine.md
