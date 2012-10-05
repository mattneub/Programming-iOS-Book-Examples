

#import "MyClass2.h"


@implementation MyClass2

- (void) observeValueForKeyPath:(NSString *)keyPath 
                       ofObject:(id)object 
                         change:(NSDictionary *)change
                        context:(void *)context {
    id newValue = [change objectForKey: NSKeyValueChangeNewKey];
    id oldValue = [change objectForKey: NSKeyValueChangeOldKey];
    NSLog(@"The key path %@ changed; where once was %@ is now %@", keyPath, oldValue, newValue);
    NSLog(@"The key path %@ is now %@", keyPath, [object valueForKeyPath: keyPath]);
}

@end
