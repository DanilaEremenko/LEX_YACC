//#ifndef 8080_EMULATOR_MACHINE_H_
//#define 8080_EMULATOR_MACHINE_H_

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "codes.h"

#define MAX_VAL		0xff

#define MEM_SIZE 1024

#define B1(val)	 val	& 7
#define B2(val)	 (val>>3) & 7
#define B3(val)	 (val>>6) & 7

#define SSEG_0 (0<<7)|(0<<6)|(1<<5)|(1<<4)|(1<<3)|(1<<2)|(1<<1)|(1<<0)
#define SSEG_1 (0<<7)|(0<<6)|(0<<5)|(0<<4)|(0<<3)|(1<<2)|(1<<1)|(0<<0)
#define SSEG_2 (0<<7)|(1<<6)|(0<<5)|(1<<4)|(1<<3)|(0<<2)|(1<<1)|(1<<0)
#define SSEG_3 (0<<7)|(1<<6)|(0<<5)|(0<<4)|(1<<3)|(1<<2)|(1<<1)|(1<<0)
#define SSEG_4 (0<<7)|(1<<6)|(1<<5)|(0<<4)|(0<<3)|(1<<2)|(1<<1)|(0<<0)
#define SSEG_5 (0<<7)|(1<<6)|(1<<5)|(0<<4)|(1<<3)|(1<<2)|(0<<1)|(1<<0)
#define SSEG_6 (0<<7)|(1<<6)|(1<<5)|(1<<4)|(1<<3)|(1<<2)|(0<<1)|(1<<0)
#define SSEG_7 (0<<7)|(0<<6)|(0<<5)|(0<<4)|(0<<3)|(1<<2)|(1<<1)|(1<<0)


struct processor_8086 {
	int mem[MEM_SIZE];
	int hashs[MEM_SIZE];
	int max_sp;
	int sp; //TODO check
	int a; //accumulator
	int b, c, d, e, h, l; //GPR
	int m; //memory
	int f; //flag register
	int psw; //TODO check
	int reg_pair[2]; //current pair
	int sseg_el[4];
}typedef processor_8086;


int machine_get_code_of_reg(char *reg_name);

int machine_get_reg(char *reg_name);

int OTD(int oct);

void execute_all();

//#endif /* 8080_EMULATOR_MACHINE_H_ */
