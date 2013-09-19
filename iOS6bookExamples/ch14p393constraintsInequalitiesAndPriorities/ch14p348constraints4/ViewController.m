

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation ViewController
- (IBAction)doButton:(id)sender {
    NSString* s = self.label.text;
    self.label.text = [s stringByAppendingString:@"xxx"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    id button = self.button;
    id label = self.label;
    
//    NSLog(@"label content hugging %f", [self.label contentHuggingPriorityForAxis:UILayoutConstraintAxisHorizontal]);
//    NSLog(@"label content compression resistance %f", [self.label contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisHorizontal]);
    
    NSDictionary* d = NSDictionaryOfVariableBindings(button,label);
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[button]-|"
      options:0 metrics:nil views:d]];
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(>=10)-[label]-[button]-(>=10)-|"
      options:NSLayoutFormatAlignAllBaseline metrics:nil views:d]];
    NSLayoutConstraint* con =
     [NSLayoutConstraint
      constraintWithItem:button attribute:NSLayoutAttributeCenterX
      relatedBy:0
      toItem:self.view attribute:NSLayoutAttributeCenterX
      multiplier:1 constant:0];
    con.priority = 700;
    [self.view addConstraint:con];
}

-(void)viewDidLayoutSubviews {
//    NSLog(@"%@", [self.label constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal]);
}


@end
