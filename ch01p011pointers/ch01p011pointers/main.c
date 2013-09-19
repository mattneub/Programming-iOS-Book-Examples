

#include <stdio.h>

int main(int argc, const char * argv[])
{
    /*
     This is to demonstrate the point that a value mutated thru one pointer affects that value
     as seen by any other pointers to the same value
     
     I can't really demonstrate this using only the syntax discussed up thru page 11
     but I want to drive home the point anyway, as it is important when we get
     to object-based programming with Objective-C
     */
    
    int i = 100;
    int* p1 = &i;
    int* p2 = &i;
    
    printf("\np1 points to %i and p2 points to %i\n", *p1, *p2);
    printf("Now I'm going to change *p1 only\n");
    
    *p1 = 200;
    
    printf("p1 points to %i and p2 points to %i\n\n", *p1, *p2);
    
    return 0;
}

