

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UILabel *lab2;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // proving that text font size shrinkage in a label works in a multiline label in iOS 7
    
    NSString* s2 = @"Fourscore and seven years ago, our fathers brought forth "
    @"upon this continent a new nation, conceived in liberty and dedicated "
    @"to the proposition that all men are created equal.";
    NSMutableAttributedString* content2 =
    [[NSMutableAttributedString alloc]
     initWithString:s2
     attributes:
     @{
       NSFontAttributeName:
           [UIFont fontWithName:@"HoeflerText-Black" size:16]
       }];
    [content2 addAttributes:
     @{
       NSFontAttributeName:[UIFont fontWithName:@"HoeflerText-Black" size:24],
       NSKernAttributeName:@-4
       } range:NSMakeRange(0,1)];
    
    self.lab.adjustsFontSizeToFitWidth = YES;
    self.lab.minimumScaleFactor = 0.7;
    
    self.lab.attributedText = content2;
    self.lab2.attributedText = content2;

}


@end
