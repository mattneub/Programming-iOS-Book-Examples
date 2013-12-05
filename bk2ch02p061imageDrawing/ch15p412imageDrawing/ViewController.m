

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iv1;
@property (weak, nonatomic) IBOutlet UIImageView *iv2;
@property (weak, nonatomic) IBOutlet UIImageView *iv3;
@property (weak, nonatomic) IBOutlet UIImageView *iv4;
@property (weak, nonatomic) IBOutlet UIImageView *iv5;
@property (weak, nonatomic) IBOutlet UIImageView *iv6;
@property (weak, nonatomic) IBOutlet UIImageView *iv7;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage* mars = [UIImage imageNamed:@"Mars"];
    CGSize sz = mars.size;
    UIGraphicsBeginImageContextWithOptions(
                                           CGSizeMake(sz.width*2, sz.height), NO, 0);
    [mars drawAtPoint:CGPointMake(0,0)];
    [mars drawAtPoint:CGPointMake(sz.width,0)];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.iv1.image = im;
    
    // ==============
    
    mars = [UIImage imageNamed:@"Mars"];
    sz = mars.size;
    UIGraphicsBeginImageContextWithOptions(
                                           CGSizeMake(sz.width*2, sz.height*2), NO, 0);
    [mars drawInRect:CGRectMake(0,0,sz.width*2,sz.height*2)];
    [mars drawInRect:CGRectMake(sz.width/2.0, sz.height/2.0, sz.width, sz.height)
           blendMode:kCGBlendModeMultiply alpha:1.0];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.iv2.image = im;
    
    // ==============
    
    mars = [UIImage imageNamed:@"Mars"];
    sz = mars.size;
    UIGraphicsBeginImageContextWithOptions(
                                           CGSizeMake(sz.width/2.0, sz.height), NO, 0);
    [mars drawAtPoint:CGPointMake(-sz.width/2.0, 0)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.iv3.image = im;
    
    // ================
    
    mars = [UIImage imageNamed:@"Mars"];
    // extract each half as a CGImage
    sz = mars.size;
    CGImageRef marsLeft = CGImageCreateWithImageInRect([mars CGImage],
                                                       CGRectMake(0,0,sz.width/2.0,sz.height));
    CGImageRef marsRight = CGImageCreateWithImageInRect([mars CGImage],
                                                        CGRectMake(sz.width/2.0,0,sz.width/2.0,sz.height));
    // draw each CGImage into an image context
    UIGraphicsBeginImageContextWithOptions(
                                           CGSizeMake(sz.width*1.5, sz.height), NO, 0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextDrawImage(con,
                       CGRectMake(0,0,sz.width/2.0,sz.height), marsLeft);
    CGContextDrawImage(con,
                       CGRectMake(sz.width,0,sz.width/2.0,sz.height), marsRight);
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(marsLeft); CGImageRelease(marsRight);

    self.iv4.image = im;
    
    // ============================
    
    mars = [UIImage imageNamed:@"Mars"];
    // extract each half as a CGImage
    sz = mars.size;
    marsLeft = CGImageCreateWithImageInRect([mars CGImage],
                                                       CGRectMake(0,0,sz.width/2.0,sz.height));
    marsRight = CGImageCreateWithImageInRect([mars CGImage],
                                                        CGRectMake(sz.width/2.0,0,sz.width/2.0,sz.height));
    // draw each CGImage into an image context
    UIGraphicsBeginImageContextWithOptions(
                                           CGSizeMake(sz.width*1.5, sz.height), NO, 0);
    con = UIGraphicsGetCurrentContext();
    CGContextDrawImage(con, CGRectMake(0,0,sz.width/2.0,sz.height),
                       flip(marsLeft));
    CGContextDrawImage(con, CGRectMake(sz.width,0,sz.width/2.0,sz.height),
                       flip(marsRight));
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(marsLeft); CGImageRelease(marsRight);
    
    self.iv5.image = im;

    // ===================
    
    mars = [UIImage imageNamed:@"Mars"];
    sz = mars.size;
    // Derive CGImage and use its dimensions to extract its halves
    CGImageRef marsCG = [mars CGImage];
    CGSize szCG = CGSizeMake(CGImageGetWidth(marsCG), CGImageGetHeight(marsCG));
    marsLeft =
    CGImageCreateWithImageInRect(
                                 marsCG, CGRectMake(0,0,szCG.width/2.0,szCG.height));
    marsRight =
    CGImageCreateWithImageInRect(
                                 marsCG, CGRectMake(szCG.width/2.0,0,szCG.width/2.0,szCG.height));
    UIGraphicsBeginImageContextWithOptions(
                                           CGSizeMake(sz.width*1.5, sz.height), NO, 0);
    // The rest is as before, calling flip() to compensate for flipping
    con = UIGraphicsGetCurrentContext();
    CGContextDrawImage(con, CGRectMake(0,0,sz.width/2.0,sz.height),
                       flip(marsLeft));
    CGContextDrawImage(con, CGRectMake(sz.width,0,sz.width/2.0,sz.height),
                       flip(marsRight));
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(marsLeft); CGImageRelease(marsRight);
    
    self.iv6.image = im;
    
    // ====================
    
    mars = [UIImage imageNamed:@"Mars"];
    sz = mars.size;
    // Derive CGImage and use its dimensions to extract its halves
    marsCG = [mars CGImage];
    szCG = CGSizeMake(CGImageGetWidth(marsCG), CGImageGetHeight(marsCG));
    marsLeft =
    CGImageCreateWithImageInRect(
                                 marsCG, CGRectMake(0,0,szCG.width/2.0,szCG.height));
    marsRight =
    CGImageCreateWithImageInRect(
                                 marsCG, CGRectMake(szCG.width/2.0,0,szCG.width/2.0,szCG.height));
    UIGraphicsBeginImageContextWithOptions(
                                           CGSizeMake(sz.width*1.5, sz.height), NO, 0);
    [[UIImage imageWithCGImage:marsLeft
                         scale:mars.scale
                   orientation:UIImageOrientationUp]
     drawAtPoint:CGPointMake(0,0)];
    [[UIImage imageWithCGImage:marsRight
                         scale:mars.scale
                   orientation:UIImageOrientationUp]
     drawAtPoint:CGPointMake(sz.width,0)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(marsLeft); CGImageRelease(marsRight);

    self.iv7.image = im;

}

CGImageRef flip (CGImageRef im) {
    CGSize sz = CGSizeMake(CGImageGetWidth(im), CGImageGetHeight(im));
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       CGRectMake(0, 0, sz.width, sz.height), im);
    CGImageRef result = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    UIGraphicsEndImageContext();
    return result;
}



@end
