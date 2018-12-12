%token<ival>TYPE
%token<text>IDENT
%token<ival>NUM
%token COMMENTS


%start lines 



/*-------------------------------------------------------*/

%union
{
    int ival;
    char *text;
};

%{
#include <stdio.h>

char *idents[20];
int idents_i = 0;

int sizes[20];
int sizes_i = 0;

int line_number = 0;

%}
	

/*-------------------------------------------------------*/
%%

lines:	lines line 				{sizes_i = 0;idents_i = 0;};
	|	lines COMMENTS			{sizes_i = 0;idents_i = 0;};
	|	lines err				{sizes_i = 0;idents_i = 0;};
	|	line 					{sizes_i = 0;idents_i = 0;};
	|	COMMENTS 				{sizes_i = 0;idents_i = 0;};
	| 	err						{sizes_i = 0;idents_i = 0;};




line:	TYPE IDENT size_seq ';'				
							{
								int size = 1;
								for(int i = 0 ; i < sizes_i ; i++)
									size*=sizes[i];
								
								
								switch($1){
								case 1:
									printf("%s:db %d\n",$2,size);
									break;
								case 2:
									printf("%s:dw %d\n",$2,size);
									break;
								case 4:
									printf("%s:dd %d\n",$2,size);
									break;
								case 8:
									printf("%s:dd %d\n",$2,size*2);
									break;
								default:
									printf("Type is not defined\n");
									break;
								}
								
							
							};
										
		|	TYPE ident_seq ';'						
							{	
								for(int i = 0;i < idents_i;i++)
									switch($1){
									case 1:
										printf("%s:db %d\n",idents[i],1);
										break;
									case 2:
										printf("%s:dw %d\n",idents[i],1);
										break;
									case 4:
										printf("%s:dd %d\n",idents[i],1);
										break;
									case 8:
										printf("%s:dd %d\n",idents[i],2);
										break;
									default:
										printf("Type is not defined\n");
										break;
									}
								

							};
										
		|	TYPE init_seq ';'					
							{		
									for(int i = 0; i < sizes_i;i++){
										switch($1){
										case 1:
											printf("%s:db %d\n",idents[i],1);
											break;
										case 2:
											printf("%s:dw %d\n",idents[i],1);
											break;
										case 4:
											printf("%s:dd %d\n",idents[i],1);
											break;
										case 8:
											printf("%s:dd %d\n",idents[i],2);
											break;
										default:
											printf("Type is not defined\n");
											break;
										}
										
										printf("mov %d %s\n",sizes[i],idents[i]);
									}
								
								
								

							};
		|	TYPE IDENT '=' '{' arr_init_seq '}' ';'
							
							{	
								switch($1){
								case 1:
									printf("%s:db %d\n",$2,1*sizes_i);
									break;
								case 2:
									printf("%s:dw %d\n",$2,1*sizes_i);
									break;
								case 4:
									printf("%s:dd %d\n",$2,1*sizes_i);
									break;
								case 8:
									printf("%s:dd %d\n",$2,2*sizes_i);
									break;
								default:
									printf("Type is not defined\n");
									break;
								}
										
									
								for(int i = 0; i < sizes_i;i++)
									printf("mov %d %s%c%d%c\n",sizes[i],$2,'[',i,']');


							};

err: IDENT IDENT size_seq ';'				
							{
								printf("type missed in size sequence : %d\n",line_number);							
							};
										
		|	IDENT ident_seq ';'						
							{	
								printf("type missed in ident sequence : %d\n",line_number);
							};
										
		|	IDENT init_seq ';'					
							{		
								printf("type missed in init sequence : %d\n",line_number);

							};
		|	IDENT IDENT '=' '{' arr_init_seq '}' ';'
							
							{	
								printf("type missed in array initializing : %d\n",line_number);
							};	
		| TYPE IDENT NUM ']' ';'	
							{	
								printf("left bracket missed : %d\n",line_number);
							};
							
		| TYPE IDENT '[' NUM ';'	
							{	
								printf("right bracket missed : %d\n",line_number);
							};									
										
arr_init_seq: arr_init_seq ',' NUM
							{
								sizes[sizes_i] = $3;
								sizes_i++;
							};

		|	NUM							
							{
											sizes[sizes_i] = $1;
											sizes_i++;
							};
										
init_seq:	init_seq ',' IDENT '=' NUM		
							{	idents[idents_i] = strdup($3);
								idents_i++;
								sizes[sizes_i] = $5;
								sizes_i++;
							};
												
		|	IDENT '=' NUM								
							{	idents[idents_i] = strdup($1);
								idents_i++;
								sizes[sizes_i] = $3;
								sizes_i++;
							};



ident_seq:	ident_seq ',' IDENT			
							{
								idents[idents_i] = strdup($3);
								idents_i++;
							};
											
		|	IDENT						
							{
								idents[idents_i] = strdup($1);
								idents_i++;
							};



size_seq:	size_seq '[' NUM ']' 		
							{
								sizes[sizes_i] = $3;
								sizes_i++;
							};
		|	'[' NUM ']' 				
							{
								sizes[sizes_i] = $2;
								sizes_i++;
							};



%%


