## Project 6
#### Due Monday, Apr. 24

------------------------------

Overview
------------------------------
We will be using pointers in assembly language to manage dynamic structures.  We will use `syscall 9` to acquire
memory space from the heap at run time. Read about the arguments and how to use `syscall 9`.  A dynamic string is
dynamically allocated to be the proper size and ends in the null character, `0`.

Program 1
------------------------------
Write an assembler language program with the following 4 functions:
- ***Length($v0, $a0)*** - returns the length of the referenced string pointed to by $a0 in register $v0.
- ***Create($v0, $a0)*** - returns a pointer in $v0 to the ASCII string that it dynamically allocates and copies the
characters in the string pointed to by the pointer in $a0 into the new string created.
- ***Append($v0, $a0, $a1)*** - returns a pointer in $v0 to the dynamic string that results from concatenating the
two ASCII strings pointed to by $a0 and $a1.
- ***Print($a0)*** - prints the string pointed to by the pointer in $a0.

The main will perform the following actions:
- Dynamically create a string, `str1`, containing `This is a test`. The value is passed via an `asciiz` string declared
in the `.data` section
- Create a string, `str2`, containing ` of our string routines`. Same as above.
- Create a string, `str3`, by appending `str2` to `str1`.
- Print a title, followed by `str1`, `str2`, and `str3`; all properly labeled.

Program 2
------------------------------
Write a second program that:
- Reads a string from the first line of a file.
- Reads a string from the next line.
- Concatenates them (without new lines).
- Prints out the new string.
