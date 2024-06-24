#ifdef DESC

	#define CMP <	

#else
	
	#define CMP >

#endif

//---------------------------------

#ifdef DEBUG

	#include <stdio.h>
	#include <stdlib.h>
	#include <fcntl.h>
	#include <time.h>
	#include <unistd.h>
	#define N 100
	#define MAX +100
	#define MIN -100
	int array[N];
	#define MAX_ELE 4
	#define PRINT_ARRAY(a) printf("["); for(int i=0;i<N-1;i++) printf("%i, ",a[i]); printf("%i]",a[N-1])
	#define DEBUG_ARRAY(a) printf("LINEA %i ----------------------------------------------\n",__LINE__); PRINT_ARRAY(a); printf("\n---------------------------------------------------------\n")

#else

	#define N (sizeof(array)/sizeof(array[0]))
	int array[] = {2,3,5,11,-1,4,5,1,13,-5,0,2};

#endif

//--------------------------------------

int main(){

#ifdef DEBUG //INIT ARRAY WITH RANDOM VALUES IN [MIN:MAX]
	unsigned int seed;
	int fd = open("/dev/urandom",O_RDONLY);
	if (fd<0){
		perror("Unable to open file '/dev/urandom' (will init with time)");
		seed=time(NULL);
	}else{
		if(read(fd,&seed,sizeof(seed))!=sizeof(seed)){
			perror("Unable to read seed from '/dev/urandom' (will init with time)");
			seed=time(NULL);
		}
		close(fd);
	}
	srand(seed);
	for(int i=0; i<N; i++){
		array[i]=rand()%(MAX-MIN)+MIN;
	}
	printf("INITIAL ARRAY:\n");
	DEBUG_ARRAY(array);
#endif


	int tmp;

#ifdef DEBUG
	printf("\nBUBBLE SORT STARTED...\n");
#endif

	for(int i=N-1; i>=0; i--){
		for(int j=0; j<=i; j++){
			if(array[j] CMP array[j+1]){
				tmp=array[j];
				array[j]=array[j+1];
				array[j+1]=tmp;
			}
		}
	}

#ifdef DEBUG
	printf("SORTED!!!\n");
	printf("\nSORTED ARRAY:\n");
	DEBUG_ARRAY(array);
#endif

}





