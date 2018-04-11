#include <stdio.h>
     
int main() { 
	// create a FILE typed pointer
	FILE *file_pointer; 
	   	    	
	// open the file "name_of_file.txt" for writing
	file_pointer = fopen("/mount_here/test_file", "w"); 
	
	// Write to the file
	fprintf(file_pointer, "Write to a test file.");
	     	    	    	    	         	    	    	    	    	fclose(file_pointer); 
     	    	    	    	         	    	    	    	    	    	return 0;    	    	    	         	    	    	 
}
