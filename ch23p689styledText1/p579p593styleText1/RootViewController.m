

#import "RootViewController.h"
#import "StyledText.h"
#import <CoreText/CoreText.h>

@interface RootViewController ()
@property (nonatomic, weak) IBOutlet StyledText *styler;
@end

@implementation RootViewController



// note ARC bridge-crossing with font2

#define which 2 // and try "2", identical but uses Objective-C

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* s = @"Yo ho ho and a bottle of rum!";
    NSMutableAttributedString* mas = [[NSMutableAttributedString alloc]  initWithString:s];
    switch (which) {
        case 1: {
            // the old way! we had to use Core Text to set attributes of an attributed string
            __block CGFloat f = 18.0;
            CTFontRef basefont = CTFontCreateWithName((CFStringRef)@"Baskerville", f, nil);
            [s enumerateSubstringsInRange:NSMakeRange(0, [s length])
                                  options:NSStringEnumerationByWords
                               usingBlock:
             ^(NSString *substring, NSRange substringRange, NSRange encRange, BOOL *stop) {
                 f += 3.5;
                 CTFontRef font2 = CTFontCreateCopyWithAttributes(basefont, f, nil, nil);
                 NSDictionary* d2 = @{(NSString*)kCTFontAttributeName: CFBridgingRelease(font2)};
                 [mas addAttributes:d2 range:encRange];
             }];
            [s enumerateSubstringsInRange:NSMakeRange(0, [s length])
                                  options: (NSStringEnumerationByWords |
                                            NSStringEnumerationReverse)
                               usingBlock:
             ^(NSString *substring, NSRange substringRange, NSRange encRange, BOOL *stop) {
                 CTFontRef font2 = CTFontCreateCopyWithSymbolicTraits (basefont, f, nil, kCTFontBoldTrait, kCTFontBoldTrait);
                 NSDictionary* d2 = @{(NSString*)kCTFontAttributeName: CFBridgingRelease(font2)};
                 [mas addAttributes:d2 range:encRange];
                 *stop = YES; // do just once, last word
             }];
            CFRelease(basefont);
            break;
        }
        case 2: {
            // exactly the same but using Objective-C where possible
            __block CGFloat f = 18.0;
            UIFont* basefont = [UIFont fontWithName:@"Baskerville" size:f];
            [s enumerateSubstringsInRange:NSMakeRange(0, [s length])
                                  options:NSStringEnumerationByWords
                               usingBlock:
             ^(NSString *substring, NSRange substringRange, NSRange encRange, BOOL *stop) {
                 f += 3.5;
                 UIFont* font2 = [UIFont fontWithName:basefont.fontName size:f];
                 NSDictionary* d2 = @{NSFontAttributeName: font2};
                 [mas addAttributes:d2 range:encRange];
             }];
            [s enumerateSubstringsInRange:NSMakeRange(0, [s length])
                                  options: (NSStringEnumerationByWords |
                                            NSStringEnumerationReverse)
                               usingBlock:
             ^(NSString *substring, NSRange substringRange, NSRange encRange, BOOL *stop) {
                 // good example of why Core Text is still useful:
                 // there's no Objective-C way to say "give me the bold variant of this font"!
                 CTFontRef font2 = CTFontCreateCopyWithSymbolicTraits ((__bridge CTFontRef)basefont, f, nil, kCTFontBoldTrait, kCTFontBoldTrait);
                 // however, CTFont is not toll-free bridged to UIFont
                 // so we have to make a new font with the same name
                 UIFont* font2b =
                 [UIFont fontWithName:CFBridgingRelease(CTFontCopyPostScriptName(font2)) size:f];
                 NSDictionary* d2 = @{NSFontAttributeName: font2b};
                 [mas addAttributes:d2 range:encRange];
                 *stop = YES; // do just once, last word
             }];
            break;
        }
    }
    
    self.styler.text = mas;
    [self.styler setNeedsDisplay];
}


@end
