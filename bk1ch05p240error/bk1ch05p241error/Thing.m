

#import "Thing.h"
#import "bk1ch05p241error-Swift.h"

@implementation Thing

- (void) dummy {
    
    NSString* f = @"";
    
    NSError* err;
    NSString* s =
        [[NSString alloc] initWithContentsOfFile:f
                                        encoding:NSUTF8StringEncoding
                                           error:&err];
    if (s == nil) {
        NSLog(@"%@", err);
    }
    
}

- (void) testThrower {
    ThrowerClass* t = [ThrowerClass new];
    NSError* err = nil;
    id dummy __attribute__((unused)) = [t throwerFuncAndReturnError:&err];
    NSLog(@"%@", err);
    // Error Domain=MyDomain Code=-666 "(null)"
    // this proves that Objective-C receives this info from Swift in good order!
}



@end
