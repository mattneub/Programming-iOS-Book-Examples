

#import "MyClass2.h"


@implementation MyClass2

- (void) observeValueForKeyPath:(NSString *)keyPath 
                       ofObject:(id)object 
                         change:(NSDictionary *)change
                        context:(void *)context {
    id newValue = [change objectForKey: NSKeyValueChangeNewKey];
    id oldValue = [change objectForKey: NSKeyValueChangeOldKey];
    NSLog(@"The key path %@ changed from %@ to %@", keyPath, oldValue, newValue);
}

@end
