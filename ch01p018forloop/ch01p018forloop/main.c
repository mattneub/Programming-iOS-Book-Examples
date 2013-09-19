
#include <stdio.h>

int main(int argc, const char * argv[])
{
    /* Demonstrating a for loop
     Notice that the counting variable defined in the scope of the for loop is confined to the for loop
     
     Feel free to play around with the code and try out other forms of flow control
     */
    
    printf("\n");
    
    int i = 100;
    
    for (int i = 0; i < 5; i++) {
        printf("Looping: i is %i\n", i);
    }
    
    printf("Outside the loop; i is %i\n\n", i);
    
    
    
    return 0;
}

