// ----------------------------------------
// DCM2PR8
// Command-line to to patch PR8 with DPCM
// ----------------------------------------
//
//

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define MAX_SAMPLES 0x40
#define PR8_DPCM_ADDRESS 0x1C800
#define PR8_ROM_HEADER 0x10
#define PR8_DPCM_END 0x1FF80
#define MAX_DPCM_BANK_SIZE (PR8_DPCM_END - PR8_DPCM_ADDRESS)

int getFileSize (FILE *file)
{
	int size;
	fseek(file, 0, SEEK_END);
	size = ftell(file);
	fseek(file, 0, SEEK_SET);
	return size;
}

struct sample {
	char name[128];
	unsigned int address;
	unsigned int length;
};

int main (int argc, const char * argv[]) {
	FILE *file;
	FILE *sample;
	char *ptr;
	char line [128];
	unsigned int sampleNumber;
	char *fileBuffer;
	struct sample sampleArray[MAX_SAMPLES];
	
	unsigned int ROM_SIZE;
	unsigned int bankSize = 0;
	unsigned int sampleSize = 0;
	unsigned int currentSampleAddress;;
	
	const char *inputName;
	const char *outputName;
	const char *patchNSF;


	if (argc < 3) {
	  printf("\n");
	  printf("DCM2PR8 V1.3: PR8 ROM Patcher\n\n");
	  printf("Usage : DCM2PR8 <patchfile.txt> <output.nes>\n\n");
	  printf("- 'patchfile.txt' needs to be a plain text file that is a list of DCM samples, one per line, that you would like to patch the PR8 ROM with.\n\n"); 
	  printf("- 'output.nes' is the patched ROM filename.\n\n");
	return 0;
	}	
	
	inputName = argv[1];
	outputName = argv[2];
	
	if (argc == 4) {
		patchNSF = argv[3];
	}
	
	//Quick, crude check to make sure maximum bank size not exceeded
	file = fopen (inputName,"r");
	if (file==NULL)
	{
		printf("\n\nError, could not open sample list %s\n\n", inputName);
		fclose(file);
		return 0;
	}
	printf("\nJust checking that your samples will all fit!\n\n");
	sampleNumber = 0;
	currentSampleAddress = 0x0000;
	while (fgets(line, sizeof line, file) !=NULL)
	{
		//Replace "newline" char with string terminator
		if( (ptr = strchr(line, '\n')) != NULL) *ptr = '\0';

		//Open and get size
		sample = fopen(line, "rb");
		if (sample == NULL)
		{
			printf("\nError, could not open file %s\n\n", line);
			fclose (sample);
			return 0;
		}
		sampleSize = getFileSize(sample);
		fclose (sample);
		
		//Store information about sample in array for patching process
		strncpy(sampleArray[sampleNumber].name, line, 128);
		sampleArray[sampleNumber].address = currentSampleAddress;
		sampleArray[sampleNumber].length = sampleSize;
		
		//Compute bank size		
		bankSize = bankSize + sampleSize;
		printf("%s ", sampleArray[sampleNumber].name);
		printf(": addr:%X size=%d\n", sampleArray[sampleNumber].address, sampleArray[sampleNumber].length);
		currentSampleAddress += sampleSize;
		sampleNumber++;
	}
	fclose(file);
	

	printf("\nMaximum bank size: %d", MAX_DPCM_BANK_SIZE);
	printf("\nYour bank size: %d\n", bankSize);

	if (currentSampleAddress > PR8_DPCM_END)
	{
		printf("\nYou were a bit optimistic, bank is %d bytes too big! Quitting.\n\n", abs(PR8_DPCM_END-currentSampleAddress));
		return -1;
	}

	//Bank size is OK so patch ROM & NSF binary
	
	printf("\nBank size is OK\n\n");
	printf("PATCHING ROM : PR8.NES\n\n");
	
	//Need "extra" address in table so that NES code can calculate sample length
	sampleArray[sampleNumber].address = currentSampleAddress;
	sampleNumber++;

	//Read ROM into buffer
	file = fopen("PR8.nes", "rb");
	if (file==NULL)
	{
		printf("\n\nError, could not find PR8 ROM, PR8.nes\n\n");
		fclose(file);
		return 0;
	}
	ROM_SIZE = getFileSize(file);
	fileBuffer = malloc(ROM_SIZE);
	fread(fileBuffer, 1, ROM_SIZE, file);	
	fclose (file);
	
	// Write new sample address table into ROM (buffer)
	int a;
	unsigned char dpcmAddress;
	for (a=0;a<sampleNumber;a++)
	{
		dpcmAddress = ((sampleArray[a].address + 0x40 + PR8_DPCM_ADDRESS) >> 6) & 0xFF;
		//printf("%X\n", (unsigned char)dpcmAddress);
		fileBuffer[PR8_DPCM_ADDRESS + PR8_ROM_HEADER + a]=dpcmAddress;
	}
	
	char *sampleBuffer;
	
	currentSampleAddress = PR8_DPCM_ADDRESS + PR8_ROM_HEADER + MAX_SAMPLES; //0x40
	for (a=0;a<(sampleNumber-1);a++)
	{
		// Read sample into memory
		sample = fopen(sampleArray[a].name,"rb");
		sampleBuffer = malloc(sampleArray[a].length);
		fread(sampleBuffer, 1, sampleArray[a].length, sample);
		fclose(sample);
		
		// Patch ROM with sample data 
		memcpy(&fileBuffer[currentSampleAddress], sampleBuffer, sampleArray[a].length);
		currentSampleAddress += sampleArray[a].length;
		free (sampleBuffer);
	}
	
	//Write buffer to ROM
	file = fopen(outputName,"wb");
	if (file==NULL)
	{
		printf("\n\nError, could not open output file, %s\n\n", outputName);
		fclose(file);
		free (fileBuffer);
		return 0;
	}
	fwrite(fileBuffer, 1, ROM_SIZE, file);
	fclose(file);
	//Free file buffer
	free (fileBuffer);
	
	return 0;
}
