

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;

@property (copy, nonatomic) NSMutableAttributedString* content;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // idea is to provide a test bed for playing with these parameters
    // you can see how both string-based and attributed-string-based label behaves
    // (and the differences between iOS 6 and iOS 7)
    
//    NSLog(@"%d", [UILabel new].lineBreakMode);
//    NSLog(@"%d", [NSParagraphStyle new].lineBreakMode);
    
    UIFont* f = [UIFont fontWithName:@"GillSans" size:20];
    
    NSTextAlignment align = NSTextAlignmentRight;
    NSLineBreakMode brk = NSLineBreakByTruncatingTail;
    NSInteger numLines = 2;

    BOOL adjusts = NO;
    CGFloat min = 0.8;
    UIBaselineAdjustment base = UIBaselineAdjustmentNone;
    
    self.lab1.adjustsFontSizeToFitWidth = adjusts;
    self.lab2.adjustsFontSizeToFitWidth = adjusts;
    self.lab1.minimumScaleFactor = min;
    self.lab2.minimumScaleFactor = min;
    self.lab1.baselineAdjustment = base;
    self.lab2.baselineAdjustment = base;
    self.lab1.numberOfLines = numLines;
    self.lab2.numberOfLines = numLines;

    NSString* s = @"Little poltergeists make up the principal form of spontaneous material manifestation.";
    self.lab1.text = s;
    self.lab1.font = f;
    self.lab1.textAlignment = align;
    self.lab1.lineBreakMode = brk;
    
    
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.alignment = align;
    para.lineBreakMode = brk;
    NSMutableAttributedString* mas =
    [[NSMutableAttributedString alloc] initWithString:s
                                           attributes:
     @{NSFontAttributeName:f,
       NSParagraphStyleAttributeName:para}];
    [mas addAttribute:NSForegroundColorAttributeName
                value:[UIColor blueColor]
                range:[s rangeOfString:@"poltergeists"]];
    self.lab2.attributedText = mas;
    

}


@end
