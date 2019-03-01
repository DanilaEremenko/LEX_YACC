//#ifndef 8080_EMULATOR_MACHINE_H_
//#define 8080_EMULATOR_MACHINE_H_

#include <stdio.h>

//REGS CODES
#define A_CODE 7
#define B_CODE 0
#define C_CODE 1
#define D_CODE 2
#define E_CODE 3
#define H_CODE 4
#define L_CODE 5
#define M_CODE 6
#define SP_CODE 6
#define PSW_CODE 6

#define HLT_OP (1<<6) | (6<<3) | (6<<0)
#define DAA_OP (0<<6) | (4<<3) | (7<<0)


int machine_get_code_of_reg(char *reg_name);

int OTD(int oct);

//#endif /* 8080_EMULATOR_MACHINE_H_ */
