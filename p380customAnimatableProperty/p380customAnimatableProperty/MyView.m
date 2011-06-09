

#import "MyView.h"
#import "MyLayer.h"


@implementation MyView

+(Class)layerClass {
    return [MyLayer class];
}


@end
