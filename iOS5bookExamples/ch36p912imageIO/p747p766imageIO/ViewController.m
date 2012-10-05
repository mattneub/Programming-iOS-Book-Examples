

#import "ViewController.h"
#import <ImageIO/ImageIO.h>

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *iv;
@end

@implementation ViewController
@synthesize iv;

- (IBAction)doButton:(id)sender {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"colson" withExtension:@"jpg"];
    CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    CFDictionaryRef result1 = CGImageSourceCopyPropertiesAtIndex(src, 0, NULL);
    NSDictionary* result = CFBridgingRelease(result1);    
    NSLog(@"%@", result);
    CFRelease(src);
}

- (IBAction)doButton2:(id)sender {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"colson" withExtension:@"jpg"];
    CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat w = (self.iv.bounds.size.width - 10)*scale;
    NSDictionary* d = 
    [NSDictionary dictionaryWithObjectsAndKeys:
     (id)kCFBooleanTrue, kCGImageSourceShouldAllowFloat,
     (id)kCFBooleanTrue, kCGImageSourceCreateThumbnailWithTransform,
     (id)kCFBooleanTrue, kCGImageSourceCreateThumbnailFromImageAlways,
     [NSNumber numberWithInt:(int)w], kCGImageSourceThumbnailMaxPixelSize,
     nil];
    CGImageRef imref = CGImageSourceCreateThumbnailAtIndex(src, 0, (__bridge CFDictionaryRef)d);
    UIImage* im = 
    [UIImage imageWithCGImage:imref scale:scale orientation:UIImageOrientationUp];
    self.iv.image = im; // assign image to UIImageView
    NSLog(@"%@ %@", im, NSStringFromCGSize(im.size));
    CFRelease(imref); CFRelease(src);
}

- (IBAction)doButton3:(id)sender {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"colson" withExtension:@"jpg"];
    CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSURL* suppurl = [fm URLForDirectory:NSApplicationSupportDirectory 
                                inDomain:NSUserDomainMask 
                       appropriateForURL:nil 
                                  create:YES error:NULL];
    NSURL* tiff = [suppurl URLByAppendingPathComponent:@"mytiff.tiff"];
    CGImageDestinationRef dest = 
    CGImageDestinationCreateWithURL((__bridge CFURLRef)tiff, 
                                    (CFStringRef)@"public.tiff", 1, NULL);
    CGImageDestinationAddImageFromSource(dest, src, 0, NULL);
    bool ok = CGImageDestinationFinalize(dest);
    if (ok)
        NSLog(@"tiff image written to disk");
    else
        NSLog(@"something went wrong");
    CFRelease(src); CFRelease(dest);
}


@end
