#include <stdio.h>
extern double bernoulliNumber(unsigned long long);
int main(){
	printf("%.10lf", bernoulliNumber(50));
}
