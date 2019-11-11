%token NUM

%{
#include <stdio.h>

int line_number =0;

int line_float	= 0;
int line_int	= 0;


%}


%start lines 
/*-------------------------------------------------------*/

%%

lines:lines line '\n' 		{
								printf("%d : int = %d, float = %d\n",line_number,line_int,line_float);
								line_int = 0;
								line_float = 0;
								line_number++;		
							};
	| line '\n'				{
								printf("%d : int = %d, float = %d\n",line_number,line_int,line_float);
								line_int = 0;
								line_float = 0;
								line_number++;										
							};
								
	| lines '\n'			{
								printf("%d : int = %d, float = %d\n",line_number,line_int,line_float);
								line_int = 0;
								line_float = 0;
								line_number++;										
							};
	| '\n'					{
								printf("%d : int = %d, float = %d\n",line_number,line_int,line_float);
								line_int = 0;
								line_float = 0;
								line_number++;										
							};

line: line int				{line_int++;};				
	| line float			{line_float++;};
	| int					{line_int++;};
	| float					{line_float++;};

float: NUM '.' NUM			;

int: NUM 					;								
%%
