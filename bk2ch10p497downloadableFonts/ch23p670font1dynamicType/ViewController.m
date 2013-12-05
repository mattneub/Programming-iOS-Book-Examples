

#import "ViewController.h"
@import CoreText;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doDynamicType:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(doDynamicType:)
//                                                 name:UIContentSizeCategoryDidChangeNotification
//                                               object:nil];
    
    
    NSString* name = @"LucidaGrande";
    CGFloat size = 12;
    UIFont* f = [UIFont fontWithName:name size:size];
    if (f) {
        self.lab.font = f;
        NSLog(@"%@", @"already installed");
        return;
    }
    NSLog(@"%@", @"attempting to download font");
    UIFontDescriptor* desc =
    [UIFontDescriptor fontDescriptorWithName:name size:size];
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler(
      (__bridge CFArrayRef)@[desc], nil,
        ^(CTFontDescriptorMatchingState state, CFDictionaryRef prog) {
            if (state == kCTFontDescriptorMatchingDidBegin) {
                NSLog(@"%@", @"matching did begin");
            }
            else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
                NSLog(@"%@", @"downloading will begin");
            }
            else if (state == kCTFontDescriptorMatchingDownloading) {
                NSDictionary* d = (__bridge NSDictionary*)prog;
                NSLog(@"progress: %@%%",
                      d[(__bridge NSString*)kCTFontDescriptorMatchingPercentage]);
            }
            else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
                NSLog(@"%@", @"downloading did finish");
            }
            else if (state == kCTFontDescriptorMatchingDidFailWithError) {
                NSLog(@"%@", @"downloading failed");
            }
            else if (state == kCTFontDescriptorMatchingDidFinish) {
                NSLog(@"%@", @"matching did finish");
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIFont* f = [UIFont fontWithName:name size:size];
                    if (f) {
                        NSLog(@"%@", @"got the font!");
                        self.lab.font = f;
                    }
                });
            }
            return (bool)YES;
        });

    
}
- (void) doDynamicType: (NSNotification*) n {
    self.lab.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}


@end
