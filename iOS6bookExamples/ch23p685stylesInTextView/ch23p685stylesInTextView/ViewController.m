

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // example from http://stackoverflow.com/questions/13127136/ - thanks!

//    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:20.],
//NSForegroundColorAttributeName: [UIColor redColor]};
//    NSAttributedString *s1 = [[NSAttributedString alloc] initWithString:@"Hello there!" attributes:attributes];
//    
//    NSMutableAttributedString *s2 = [[NSMutableAttributedString alloc] initWithString:@"Hello where?"];
//    [s2 addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(3, 5)];
//        
//    self.lab.attributedText = s1;
//    self.lab.attributedText = s2;
//    
//    // the text view retains features of the first string's first char when you assign the 2nd string
//    // (the label does not behave this way)
//    // to avoid that surprise, always reset the base properties to nil before assigning new string
//    // (uncomment the commented-out four lines to try that)
//    
//    self.tv.attributedText = s1;
////    self.tv.text = nil;
////    self.tv.font = nil;
////    self.tv.textColor = nil;
////    self.tv.textAlignment = NSTextAlignmentLeft;
//    self.tv.attributedText = s2;

    NSAttributedString* s1 = [[NSAttributedString alloc] initWithString:@"Hello there!" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    NSAttributedString* s2 = [[NSAttributedString alloc] initWithString:@"Howdy"];
    self.lab.attributedText = s1;
    self.lab.attributedText = s2;
    self.tv.attributedText = s1;
    self.tv.text = nil;
    self.tv.font = nil;
    self.tv.textColor = nil;
    self.tv.textAlignment = NSTextAlignmentLeft;
    NSLog(@"%@", self.tv.textColor);
    self.tv.attributedText = s2;

    
}


@end
