//#ifndef 8080_EMULATOR_MACHINE_H_
//#define 8080_EMULATOR_MACHINE_H_

#define MEM_SIZE 1024


struct processor_8086{
	int mem[MEM_SIZE];
	int sp;//TODO check
	int a;//acumul
	int b,c,d,e,h,l,m;//GPR
	int pws;//flag register
}typedef processor_8086;

void machine_init_processor_8086();


void machine_print_mem(int from, int to);

void machine_print_all_reg();

//#endif /* 8080_EMULATOR_MACHINE_H_ */
