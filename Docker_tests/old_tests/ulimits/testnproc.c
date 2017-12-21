#include<stdio.h>
#include <sys/resource.h>
#include <errno.h>
int main( int argc, char *argv[] )
{
	int i;
	int p[1500];
	// get nproc limit
        struct rlimit rl;
        if ( getrlimit( RLIMIT_NPROC , &rl) != 0 ) {
            printf("getrlimit() failed with errno=%d\n", errno);
                return 255;
        };
	// fork 1500 times
	for( i=1 ; i<= 1500 ; i++ ) {
		p[i] = fork();
		if ( p[i] >= 0 ) {
			if (  p[i] == 0 ) {
				printf("parent says fork number %d sucessful \n" , i ); 
			} else {
				printf(" child says fork number %d pid %d \n" , i , p[i] ); 
				sleep(10);
				break;
			}
		} else {
	    		printf("parent says fork number %d failed (nproc: soft=%d hard=%d) with errno=%d\n", i, rl.rlim_cur , rl.rlim_max , errno);
			return 255;
		}
	}
}
