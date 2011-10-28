

#import "CompassView.h"
#import "CompassLayer.h"

@implementation CompassView

+ (Class) layerClass { 
    return [CompassLayer class];
}

@end
