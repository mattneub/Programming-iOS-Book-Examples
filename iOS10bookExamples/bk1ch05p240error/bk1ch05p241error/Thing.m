

#import "Thing.h"

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

@end
