

#import "MyClass2.h"


@implementation MyClass2

- (void) observeValueForKeyPath:(NSString *)keyPath 
                       ofObject:(id)object 
                         change:(NSDictionary *)change
                        context:(void *)context {
    NSLog(@"I heard about the change!");
}

@end
