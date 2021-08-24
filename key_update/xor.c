/*
########################################################################
## AUTHOR : Santiago Torres Borda
## CREATION DATE : 12/07/2021
## PURPOSE : Compute bitwise XOR between two strings
## SPECIAL NOTES: $1: First string
##                $2: Second string
########################################################################
## Version: 1.0
########################################################################
*/
#include<stdio.h>
#include<stdlib.h>

int main(int argc, char *argv[]){
	unsigned int xor = (unsigned int)strtol(argv[1], NULL, 16)^(unsigned int)strtol(argv[2], NULL, 16);;
	printf("%x\n",xor);
	return 0;
}
