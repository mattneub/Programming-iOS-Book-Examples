
#import "MyElaborateActivity.h"
#import "ElaborateViewController.h"

@interface MyElaborateActivity()
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, strong) UIImage* image;
@end

// in iOS 7, this works on iPhone and on iPad


@implementation MyElaborateActivity

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
    return @"com.neuburg.matt.elaborateActivity";
}

-(NSString *)activityTitle {
    return @"Elaborate";
}

-(UIImage *)activityImage {
    return self.image;
}

-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    NSLog(@"can perform %@", activityItems);
    return YES;
}

-(void)prepareWithActivityItems:(NSArray *)activityItems {
    NSLog(@"prepare %@", activityItems);
    self.items = activityItems;
}

-(UIViewController *)activityViewController {
    ElaborateViewController* evc = [ElaborateViewController new];
    evc.activity = self;
    evc.items = self.items;
    return evc;
}

-(void) dealloc {
    NSLog(@"%@", @"elaborate activity dealloc");
}



@end
