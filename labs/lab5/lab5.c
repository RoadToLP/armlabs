#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <math.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb/stb_image_write.h"
extern void resizeImage(unsigned char*, unsigned char*, double, double, int, int, int, int);
int main(int argc, char** argv){
	char* input = 0;
	char* output = 0;
	int width, height, channels;
	int newWidth, newHeight;
	if (argc != 5){
		fprintf(stderr, "Usage: %s <input> <output> <newWidth> <newHeight>\n", argv[0]);
		exit(-1);
	}
	input = argv[1];
	output = argv[2];
	char* ptr;
	newWidth = strtol(argv[3], &ptr, 10);
	newHeight = strtol(argv[4], &ptr, 10);

	if (access(input, F_OK) != 0){
		fprintf(stderr, "Input file does not exist\n");
		exit(-1);
	}
	int fd = 0;
	if ((fd = open(output, O_CREAT | O_WRONLY | O_TRUNC, 0644)) == -1){
		fprintf(stderr, "Can't open output for writing\n");
		exit(-1);
	}
	close(fd);
	unsigned char* inputData = stbi_load(input, &width, &height, &channels, 0);
	if (!input){
		fprintf(stderr, "Couldn't load the image\n");
		exit(-1);
	}
	unsigned char* outputData = malloc(newWidth * newHeight * 3);
	if (!output){
		fprintf(stderr, "Failed to allocate memory");
		exit(-1);
	}
	printf("%s\n", output);
	resizeImage(outputData, inputData, (double)width/newWidth, (double)height/newHeight, width, height, newWidth, newHeight);
	printf("%s\n", output);
	stbi_write_jpg(output, newWidth, newHeight, channels, outputData, 100);
	stbi_image_free(inputData);
	free(outputData);
}
