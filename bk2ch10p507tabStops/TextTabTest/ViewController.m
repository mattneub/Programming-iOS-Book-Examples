

#import "ViewController.h"
@import ImageIO;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tv;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString* s = @"Onions\t$2.34\nPeppers\t$15.2\n";
    NSMutableParagraphStyle* p = [NSMutableParagraphStyle new];
    NSMutableArray* tabs = [NSMutableArray new];
    NSCharacterSet* terms = [NSTextTab columnTerminatorsForLocale:[NSLocale currentLocale]];
    NSTextTab* tab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentRight location:170 options:@{NSTabColumnTerminatorsAttributeName:terms}];
    [tabs addObject:tab];
    p.tabStops = tabs;
    p.firstLineHeadIndent = 20;
    NSMutableAttributedString* mas = [[NSMutableAttributedString alloc] initWithString:s attributes:@{NSFontAttributeName:[UIFont fontWithName:@"GillSans" size:15], NSParagraphStyleAttributeName:p}];
    self.tv.attributedText = mas;
    
    return; // comment out to see images

    UIImage* onions = [self thumbnailOfImageWithName:@"onion" extension:@"jpg"];
    UIImage* peppers = [self thumbnailOfImageWithName:@"peppers" extension:@"jpg"];
    
    NSTextAttachment* onionatt = [NSTextAttachment new];
    onionatt.image = onions;
    onionatt.bounds = CGRectMake(0,-5,onions.size.width,onions.size.height);
    NSAttributedString* onionattchar = [NSAttributedString attributedStringWithAttachment:onionatt];
    
    NSTextAttachment* pepperatt = [NSTextAttachment new];
    pepperatt.image = peppers;
    pepperatt.bounds = CGRectMake(0,-1,peppers.size.width,peppers.size.height);
    NSAttributedString* pepperattchar = [NSAttributedString attributedStringWithAttachment:pepperatt];

    
    NSRange r = [[mas string] rangeOfString:@"Onions"];
    [mas insertAttributedString:onionattchar atIndex:(r.location + r.length)];
    r = [[mas string] rangeOfString:@"Peppers"];
    [mas insertAttributedString:pepperattchar atIndex:(r.location + r.length)];

    self.tv.attributedText = mas;
    
}

- (UIImage*) thumbnailOfImageWithName: (NSString*) name extension: (NSString*) ext {
    NSURL* url =
    [[NSBundle mainBundle] URLForResource:name
                            withExtension:ext];
    CGImageSourceRef src =
    CGImageSourceCreateWithURL((__bridge CFURLRef)url, nil);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat w = 20*scale;
    NSDictionary* d =
    @{(id)kCGImageSourceShouldAllowFloat: (id)kCFBooleanTrue,
      (id)kCGImageSourceCreateThumbnailWithTransform: (id)kCFBooleanTrue,
      (id)kCGImageSourceCreateThumbnailFromImageAlways: (id)kCFBooleanTrue,
      (id)kCGImageSourceThumbnailMaxPixelSize: @((int)w)};
    CGImageRef imref =
    CGImageSourceCreateThumbnailAtIndex(src, 0, (__bridge CFDictionaryRef)d);
    UIImage* im =
    [UIImage imageWithCGImage:imref scale:scale
                  orientation:UIImageOrientationUp];
    CFRelease(imref); CFRelease(src);
    return im;
}


@end
