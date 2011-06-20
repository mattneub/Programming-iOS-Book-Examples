

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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io {
    return io == UIInterfaceOrientationLandscapeRight;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* s = @"Yo ho ho and a bottle of rum!";
    NSMutableAttributedString* mas = [[NSMutableAttributedString alloc]  initWithString:s];
    __block CGFloat f = 18.0;
    CTFontRef basefont = CTFontCreateWithName((CFStringRef)@"Baskerville", f, NULL);
    [s enumerateSubstringsInRange:NSMakeRange(0, [s length]) 
                          options:NSStringEnumerationByWords 
                       usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange encRange, BOOL *stop) {
         f += 3.5;
         CTFontRef font2 = CTFontCreateCopyWithAttributes(basefont, f, NULL, NULL);
         NSDictionary* d2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                             (id)font2, (NSString*)kCTFontAttributeName, nil];
         [mas addAttributes:d2 range:encRange];
         CFRelease(font2);
         [d2 release];
     }];
    [s enumerateSubstringsInRange:NSMakeRange(0, [s length]) 
                          options: (NSStringEnumerationByWords | 
                                    NSStringEnumerationReverse)
                       usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange encRange, BOOL *stop) {
         CTFontRef font2 = CTFontCreateCopyWithSymbolicTraits (basefont, f, NULL, kCTFontBoldTrait, kCTFontBoldTrait);
         NSDictionary* d2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                             (id)font2, (NSString*)kCTFontAttributeName, nil];
         [mas addAttributes:d2 range:encRange];
         CFRelease(font2);
         *stop = YES; // do just once, last word
     }];
    self.styler.text = mas;
    [self.styler setNeedsDisplay];
    [mas release];
    CFRelease(basefont);
}


@end
