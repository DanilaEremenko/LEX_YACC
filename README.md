# 8080 EMULATOR GUIDE

## BUILDING & EXECUTION & CLEANING :

1) Compile emulator
```
./build.sh -c 8080_emulator
```
2) Execute all *.in files in directory (must be used only after compilation) and print result to stdout
```
./build.sh -e 8080_emulator
```
3) Remove all out files in directory
```
./build.sh -r 8080_emulator
```

## INPUT FILE EXAMPLE:
```
/*@initializing-----------------------------------------------*/
000:LXI SP;		/*initialize SP*/
001:200;
002:000;
003:LXI H;		/*HL - addres of  v1*/
004:206;	
005:000;
006:LXI D;		/*DE = address of v2*/
007:207;
010:000;
011:JMP;		/*just test jump*/
012:021;
013:000;

/*@exchange v1 <-> v2---------------*/
021:MOV A,M;	/*A = v1 (&v1 = HL)		*/
022:PUSH PSW;	/*save v1			*/
023:LDAX D;		/*A = v2 (&v2 = DE)	*/
024:MOV M,A;	/*&v1 = v2			*/
025:POP PSW;	/*A = v1			*/
026:STAX D;		/*&v2 = v1		*/
027:JMP;
028:104;
029:000;

/*@lonely sad HLT for JMP testing (NOTE:execution of your programs stops when pc = &HLT)*/
104:HLT;

/*exchanged variables*/
206:111;		/*v1*/
207:222;		/*v2*/

/*@Define mem areas which will be printed after executing	*/
FROM 0 TO 13;		/*binary code of initializing		*/
FROM 21 TO 29;		/*binary code of exchange v1 <-> v2	*/
FROM 104 TO 104;	/*binary code of lonelye sad HLT	*/
FROM 174 TO 200;	/*check stack				*/
FROM 206 TO 207;	/*check that v1 and v2 was exchanged	*/


/*@Execute code on emulator. Code will not be executed without this line!*/
EXEC;			

```
## OUTPUT FILE EXAMPLE:

```
	z_0_example.out

----------regs----------
a 	= 111
b 	= 0
c 	= 0
d 	= 0
e 	= 207
h 	= 0
l 	= 206
m 	= 0
pws	= 0
sp 	= 200
f 	= 100
----------mem(0-13)---------
000:061
001:200
002:000
003:041
004:206
005:000
006:021
007:207
010:000
011:303
012:021
013:000
----------mem(21-31)---------
021:176
022:365
023:032
024:167
025:361
026:022
027:303
030:104
031:000
----------mem(104-104)---------
104:166
----------mem(174-200)---------
174:000
175:000
176:100
177:111
200:000
----------mem(206-207)---------
206:222
207:111
----------flags---------
```


