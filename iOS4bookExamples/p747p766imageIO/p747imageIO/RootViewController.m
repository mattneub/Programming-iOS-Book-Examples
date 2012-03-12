

#import "RootViewController.h"
#import <ImageIO/ImageIO.h>

@implementation RootViewController
@synthesize iv;

- (IBAction)doButton:(id)sender {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"colson" withExtension:@"jpg"];
    CGImageSourceRef src = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    NSDictionary* result = (id)CGImageSourceCopyPropertiesAtIndex(src, 0, NULL);
    NSLog(@"%@", result);
    CFRelease(src);
    [result release];
}

- (IBAction)doButton2:(id)sender {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"colson" withExtension:@"jpg"];
    CGImageSourceRef src = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat scale = [UIScreen mainScreen].scale;
    NSDictionary* d = 
    [NSDictionary dictionaryWithObjectsAndKeys:
     (id)kCFBooleanTrue, kCGImageSourceShouldAllowFloat,
     (id)kCFBooleanTrue, kCGImageSourceCreateThumbnailWithTransform,
     (id)kCFBooleanTrue, kCGImageSourceCreateThumbnailFromImageAlways,
     [NSNumber numberWithInt:100*scale], kCGImageSourceThumbnailMaxPixelSize,
     nil];
    CGImageRef imref = CGImageSourceCreateThumbnailAtIndex(src, 0, (CFDictionaryRef)d);
    UIImage* im = 
    [UIImage imageWithCGImage:imref scale:scale orientation:UIImageOrientationUp];
    self->iv.image = im; // assign image to UIImageView
    CFRelease(imref); CFRelease(src);
}

- (IBAction)doButton3:(id)sender {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"colson" withExtension:@"jpg"];
    CGImageSourceRef src = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSURL* suppurl = [fm URLForDirectory:NSApplicationSupportDirectory 
                                inDomain:NSUserDomainMask 
                       appropriateForURL:nil 
                                  create:YES error:NULL];
    NSURL* tiff = [suppurl URLByAppendingPathComponent:@"mytiff.tiff"];
    CGImageDestinationRef dest = 
    CGImageDestinationCreateWithURL((CFURLRef)tiff, 
                                    (CFStringRef)@"public.tiff", 1, NULL);
    CGImageDestinationAddImageFromSource(dest, src, 0, NULL);
    bool ok = CGImageDestinationFinalize(dest);
    if (ok)
        NSLog(@"tiff image written to disk");
    else
        NSLog(@"something went wrong");
    [fm release]; CFRelease(src); CFRelease(dest);
}


- (void)dealloc {
    [iv release];
    [super dealloc];
}

@end
