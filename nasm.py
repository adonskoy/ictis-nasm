#! /usr/bin/env python3
import os, sys, subprocess
count = len(sys.argv)
if(count==1):
	print("Укажите название nasm файла")
else:
	file_name = sys.argv[1].split(".")[0]
	print("Compiling nasm file...")
	os.system("nasm -g -f elf -o {name}.o -l {name}.list {file}".format(name=file_name, file=sys.argv[1]))
	print("Creating object file...")
	os.system("ld -m elf_i386 -o {name} {name}.o".format(name=file_name))
	if(count==3):
		print("Running debug util...")
		os.system("gdb -q -x {gdb_file}".format(gdb_file=sys.argv[2]))
	else:
		print("Do you want to run debug util? [Y/n]", end =" ")
		if(input().lower()=='y'):
			print("Well, running debug util...\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
			os.system("gdb -q -x default.gdb")
		else:
			print("Okay, running the program in normal mode...")
			os.system("./{name}".format(name=file_name))