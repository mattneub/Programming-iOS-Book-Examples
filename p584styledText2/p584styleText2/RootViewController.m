

#import "RootViewController.h"
#import "StyledText.h"
#import <CoreText/CoreText.h>

@implementation RootViewController
@synthesize styler;

- (void)dealloc
{
    [styler release];
    [super dealloc];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"];
    NSString* s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    CTFontRef font = CTFontCreateWithName((CFStringRef)@"Didot", 18, NULL);
    CTFontDescriptorRef fontdesc1 = CTFontCopyFontDescriptor(font);
    CTFontDescriptorRef fontdesc2 = 
    CTFontDescriptorCreateCopyWithFeature(fontdesc1, 
                                          (CFNumberRef)[NSNumber numberWithInt:3],
                                          (CFNumberRef)[NSNumber numberWithInt:3]);
    CTFontRef basefont = CTFontCreateWithFontDescriptor(fontdesc2, 0, NULL);
    NSDictionary* d = [[NSDictionary alloc] initWithObjectsAndKeys:(id)basefont, 
                       (NSString*)kCTFontAttributeName, nil];
    NSMutableAttributedString* mas = 
    [[NSMutableAttributedString alloc] initWithString:s attributes:d];
    [d release];
    
    CTTextAlignment centerValue = kCTCenterTextAlignment;
    CTParagraphStyleSetting center = 
    {kCTParagraphStyleSpecifierAlignment, sizeof(centerValue), &centerValue};
    CTParagraphStyleSetting pss[1] = {center};
    CTParagraphStyleRef ps = CTParagraphStyleCreate(pss, 1);
    [mas addAttribute:(NSString*)kCTParagraphStyleAttributeName 
                value:(id)ps 
                range:NSMakeRange(0, [s length])];
    CFRelease(ps);

    self.styler.text = mas;
    [mas release];

}
@end
