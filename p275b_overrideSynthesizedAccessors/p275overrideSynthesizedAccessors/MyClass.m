

#import "MyClass.h"

// private property myIvarAlias
@interface MyClass () 
@property (nonatomic, retain) NSNumber* myIvarAlias; 
@end

@implementation MyClass

@synthesize myIvarAlias=myIvar;

// myIvarAlias is a private property name; it is backed by the ivar myIvar
// getter and setter for myIvar pass thru synthesized accessors for myIvarAlias
// since we are writing them explicitly, they can also do other stuff
// thus we can take advantage of synthesized yummy goodness while adding functionality

- (void) setMyIvar: (NSNumber*) num { 
    // do other stuff here
    NSLog(@"doing other stuff in setter");
    self.myIvarAlias = num;
}

- (NSNumber*) myIvar {
    // do other stuff here 
    NSLog(@"doing other stuff in getter");
    return self.myIvarAlias;
}

- (void)dealloc {
    [self->myIvar release];
    [super dealloc];
}

@end
