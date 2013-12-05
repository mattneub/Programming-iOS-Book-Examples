

#import "ViewController.h"
@import ImageIO;

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *iv;
@end

@implementation ViewController

- (IBAction)doButton:(id)sender {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"colson" withExtension:@"jpg"];
    CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef)url, nil);
    CFDictionaryRef result1 = CGImageSourceCopyPropertiesAtIndex(src, 0, nil);
    NSDictionary* result = CFBridgingRelease(result1);
    NSLog(@"%@", result);
    CFRelease(src);
}

- (IBAction)doButton2:(id)sender {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"colson" withExtension:@"jpg"];
    CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef)url, nil);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat w = (self.iv.bounds.size.width)*scale;
    NSDictionary* d =
    @{(id)kCGImageSourceShouldAllowFloat: (id)kCFBooleanTrue,
      (id)kCGImageSourceCreateThumbnailWithTransform: (id)kCFBooleanTrue,
      (id)kCGImageSourceCreateThumbnailFromImageAlways: (id)kCFBooleanTrue,
      (id)kCGImageSourceThumbnailMaxPixelSize: @((int)w)};
    CGImageRef imref = CGImageSourceCreateThumbnailAtIndex(src, 0, (__bridge CFDictionaryRef)d);
    UIImage* im =
    [UIImage imageWithCGImage:imref scale:scale orientation:UIImageOrientationUp];
    self.iv.image = im; // assign image to UIImageView
    NSLog(@"%@ %@", im, NSStringFromCGSize(im.size));
    CFRelease(imref); CFRelease(src);
}

- (IBAction)doButton3:(id)sender {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"colson" withExtension:@"jpg"];
    CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef)url, nil);
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSURL* suppurl = [fm URLForDirectory:NSApplicationSupportDirectory
                                inDomain:NSUserDomainMask
                       appropriateForURL:nil
                                  create:YES error:nil];
    NSURL* tiff = [suppurl URLByAppendingPathComponent:@"mytiff.tiff"];
    CGImageDestinationRef dest =
    CGImageDestinationCreateWithURL((__bridge CFURLRef)tiff,
                                    (CFStringRef)@"public.tiff", 1, nil);
    CGImageDestinationAddImageFromSource(dest, src, 0, nil);
    bool ok = CGImageDestinationFinalize(dest);
    if (ok)
        NSLog(@"tiff image written to disk");
    else
        NSLog(@"something went wrong");
    CFRelease(src); CFRelease(dest);
}


@end
