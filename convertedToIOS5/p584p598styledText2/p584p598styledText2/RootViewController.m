

#import "RootViewController.h"
#import "StyledText.h"
#import <CoreText/CoreText.h>

@interface RootViewController ()
@property (nonatomic, weak) IBOutlet StyledText *styler;
@end

@implementation RootViewController
@synthesize styler;

// more fun with ARC, and hey, I fixed a leak

-(void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"];
    NSString* s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    CTFontRef font = CTFontCreateWithName((CFStringRef)@"Didot", 18, NULL);
    CTFontDescriptorRef fontdesc1 = CTFontCopyFontDescriptor(font);
    CTFontDescriptorRef fontdesc2 = 
    CTFontDescriptorCreateCopyWithFeature(fontdesc1, 
                                          (__bridge CFNumberRef)[NSNumber numberWithInt:3],
                                          (__bridge CFNumberRef)[NSNumber numberWithInt:3]);
    CTFontRef basefont = CTFontCreateWithFontDescriptor(fontdesc2, 0, NULL);
    NSDictionary* d = [[NSDictionary alloc] initWithObjectsAndKeys:CFBridgingRelease(basefont), 
                       (NSString*)kCTFontAttributeName, nil];
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
