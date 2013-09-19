
#import "MyElaborateActivity.h"
#import "ElaborateViewController.h"

@interface MyElaborateActivity()
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, strong) UIImage* image;
@end

// works on iPhone but not on iPad, and I haven't found a solution
// appears fullscreen modal, is never dismissed, view controller is dealloced twice, and UIActivity leaks
// I have to assume this is a bug in the API itself


@implementation MyElaborateActivity

-(id)init {
    self = [super init];
    if (self) {
        UIImage* im = [UIImage imageNamed:@"sunglasses.png"];
        CGFloat largerSize = fmaxf(im.size.height, im.size.width);
        CGFloat scale = 43.0/largerSize;
        CGSize sz = CGSizeMake(im.size.width*scale, im.size.height*scale);
        UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
        [im drawInRect: (CGRect) {CGPointZero, sz}];
        im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self->_image = im;
    }
    return self;
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
