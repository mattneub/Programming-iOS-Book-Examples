

#include <stdio.h>

/* demonstrating how a function is declared, called, and defined */

/* In the book I don't go into the fact that you can't have a function inside a function
 But you can't, and since the call to square is inside main,
 the definition of square must be outside main
 */

/* So in this example we have the declaration of square;
 then the main function which calls square;
 then the definition of main
 */

// declaration so subsequent code can call the function
int square(int i);


int main (int argc, const char * argv[])
{
    
    // calling the function
    int i = 3;
    printf("\nI'm going to call square with an argument of %i\n", i);
    
    i = square(i);
    printf("I did call square and the result was %i\n\n", i);
    
    
    return 0;
}

// definition for the function
int square(int i) {
    return i * i;
};

