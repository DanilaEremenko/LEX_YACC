/*
 * codes.h
 *
 *  Created on: Mar 23, 2019
 *      Author: danila
 */

//#ifndef 8080_EMULATOR_CODES_H_
//#define 8080_EMULATOR_CODES_H_

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

//-----------------------------------MOV


//-----------------------------------MOV

#define MOV_H 	1
#define MVI_H 	2
#define LXI_H 	3
#define LDA_H 	4
#define LDAX_H 	5
#define STA_H 	6
#define STAX_H 	7
#define	IN_H 	8
#define	OUT_H 	9
#define XCHG_H 	10
#define XTHL_H	11
#define LHLD_H	12
#define SHLD_H	13
#define SPHL_H	14
#define PUSH_H	16
#define POP_H	17
#define JMP_H	18
#define CALL_H	19
#define RET_H	20
#define PCHL_H	21
#define RST_H	22
#define JNZ_H	23
#define JZ_H	24
#define JNC_H	25
#define JC_H	26
#define JPO_H	27
#define JPE_H	28
#define JP_H	29
#define JM_H	30
#define CNZ_H	31
#define CZ_H	32
#define CNC_H	33
#define CC_H	34
#define CPO_H	35
#define CPE_H	36
#define CP_H	37
#define CM_H	39
#define RNZ_H	40
#define RZ_H	41
#define RNC_H	42
#define RC_H	43
#define RPO_H	44
#define RPE_H	45
#define RP_H	46
#define RM_H	47
#define EI_H	48
#define DI_H	49
#define NOP_H	50
#define HLT_H	51
#define ADD_H	52
#define ADI_H	53
#define ADC_H	54
#define ACI_H	55
#define SUB_H	56
#define SUI_H	57
#define SBB_H	58
#define SBI_H	59
#define CMP_H	60
#define CPI_H	61
#define INR_H	62
#define INX_H	63
#define DCR_H	64
#define DCX_H	65
#define DAD_H	66
#define DAA_H	67
#define ANA_H	68
#define ANI_H	69
#define XRA_H	70
#define XRI_H	71
#define ORA_H	72
#define ORI_H	73
#define CMA_H	74
#define RLC_H	75
#define RRC_H	76
#define RAL_H	77
#define RAR_H	78
#define STC_H	79
#define CMC_H	80



//FLAGS
#define FLAG_DEF	0xff
#define FLAG_SIGN 	(1<<7)
#define FLAG_ZERO 	(1<<6)
#define FLAG_AC		(1<<4)
#define FLAG_PAR	(1<<2)
#define FLAG_CARRY 	(1<<0)






//#endif /* 8080_EMULATOR_CODES_H_ */
