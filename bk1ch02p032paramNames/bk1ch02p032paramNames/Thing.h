

#import <Foundation/Foundation.h>

@interface Thing : NSObject

- (Thing* __nonnull) thingByCrushingInstancesOfThing: (Thing* __nonnull) otherThing;
// renamified to `func crushingInstances(of otherThing: Thing) -> Thing`

@end
