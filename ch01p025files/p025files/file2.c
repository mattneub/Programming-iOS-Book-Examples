

#include "file2.h"

#include <stdio.h>

// also include file1.h to get the declaration for square

#include "file1.h"

void doYourThing(void) {
    
    printf("\nThis is doYourThing in file2.c\n");
    
    int i = 3;
    
    printf("I am about to call square with an argument of %i\n", i);
    i = square(3);
    printf("I did call square and the result was %i\n", i);
    
    printf("The question to ask yourself is: How was doYourThing in file2.c able to call square in file1.c?\n\n");
    
    /* And if you understand the answer to that question, you understand about file organization in a C program! */
    
}