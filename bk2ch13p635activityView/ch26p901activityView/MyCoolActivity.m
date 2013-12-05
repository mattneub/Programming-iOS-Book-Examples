

#import "MyCoolActivity.h"

@interface MyCoolActivity()
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, strong) UIImage* image;
@end

@implementation MyCoolActivity

-(id)init {
    self = [super init];
    if (self) {
        CGFloat scale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 76 : 60;
        scale -= 10;
        UIImage* im = [UIImage imageNamed:@"sunglasses.png"];
        CGFloat largerSize = fmaxf(im.size.height, im.size.width);
        scale /= largerSize;
        CGSize sz = CGSizeMake(im.size.width*scale, im.size.height*scale);
        UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
        [im drawInRect: (CGRect) {CGPointZero, sz}];
        im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self->_image = im;
    }
    return self;
}

+(UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

-(NSString *)activityType {
    return @"com.neuburg.matt.coolActivity";
}

-(NSString *)activityTitle {
    return @"Be Cool";
}

-(UIImage *)activityImage {
    return self.image;
}

-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    NSLog(@"can perform %@", activityItems);
    for (id obj in activityItems) {
        if ([obj isKindOfClass: [NSString class]])
            return YES;
    }
    return NO;
}

-(void)prepareWithActivityItems:(NSArray *)activityItems {
    NSLog(@"prepare %@", activityItems);
    self.items = activityItems;
}

-(void)performActivity {
    NSLog(@"performing %@", self.items);
    [self activityDidFinish:YES];
}


@end
