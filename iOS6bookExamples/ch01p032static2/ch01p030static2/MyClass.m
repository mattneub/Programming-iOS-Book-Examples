
#import "MyClass.h"

@implementation MyClass

-(void)doYourThing {
    static BOOL beenThereDoneThat = NO;
    if (!beenThereDoneThat) {
        beenThereDoneThat = YES;
    } else {
        NSLog(@"been there done that");
    }
}

@end
