#include <stdio.h>

// just proving that static variables actually work

int myfunction() {
    static int result = 0; // 0 means we haven't done the calculation yet
    if (result == 0) {
        result = 100; // pretend this is an expensive calculation
        printf("\n\nCalculating result for the first and only time\n");
    }
    return result;
}

int main (int argc, const char * argv[])
{
    printf("result is %i\n", myfunction());
    printf("result is %i\n", myfunction());
    printf("result is %i\n", myfunction());
    printf("\n");
    
    return 0;
}

