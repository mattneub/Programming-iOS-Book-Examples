

#import "MyClass.h"

@implementation MyClass {
    /* __weak */ id _thing;
}

- (void) setThing: (id) what {
    self->_thing = what;
}

-(void)dealloc {
    NSLog(@"%@", @"dealloc");
}

@end
