

#import "RootViewController.h"
#import "StyledText.h"
#import <CoreText/CoreText.h>

@interface RootViewController ()
@property (nonatomic, weak) IBOutlet StyledText *styler;
@end

@implementation RootViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // this remains an example of something I'm pretty sure you can't do with Objective-C
    // the problem is that these special font features are available only through CTFont
    // and once you've used CTFont in an NSAttributedString...
    // ...you can never hand that string to UIKit for drawing (you'll crash if you try)
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"];
    NSString* s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    CTFontRef font = CTFontCreateWithName((CFStringRef)@"Didot", 18, nil);
    CTFontDescriptorRef fontdesc1 = CTFontCopyFontDescriptor(font);
    // names come from SFNTLayoutTypes.h (iOS 6 new feature)
    // these are said to be deprecated, but the non-deprecated values don't work for Didot
    CTFontDescriptorRef fontdesc2 = 
    CTFontDescriptorCreateCopyWithFeature(fontdesc1, 
                                          (__bridge CFNumberRef)@(kLetterCaseType),
                                          (__bridge CFNumberRef)@(kSmallCapsSelector));
    CTFontRef basefont = CTFontCreateWithFontDescriptor(fontdesc2, 0, nil);
    NSDictionary* d = @{(NSString*)kCTFontAttributeName: CFBridgingRelease(basefont)};
    NSMutableAttributedString* mas = 
    [[NSMutableAttributedString alloc] initWithString:s attributes:d];
    
    CTTextAlignment centerValue = kCTCenterTextAlignment;
    CTParagraphStyleSetting center = 
    {kCTParagraphStyleSpecifierAlignment, sizeof(centerValue), &centerValue};
    CTParagraphStyleSetting pss[1] = {center};
    CTParagraphStyleRef ps = CTParagraphStyleCreate(pss, 1);
    [mas addAttribute:(NSString*)kCTParagraphStyleAttributeName 
                value:CFBridgingRelease(ps) 
                range:NSMakeRange(0, [s length])];

    self.styler.text = mas;
    
    CFRelease(font); CFRelease(fontdesc1); CFRelease(fontdesc2); // leaking previously

}
@end
