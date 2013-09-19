

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController
- (IBAction)doWiden:(id)sender {
    
    self.lab1.text = [self.lab1.text stringByAppendingString:@"xxxxx"];
    self.lab2.text = [self.lab2.text stringByAppendingString:@"xxxxx"];
    self.label.text = [self.label.text stringByAppendingString:@"xxxxx"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.lab1.translatesAutoresizingMaskIntoConstraints = NO;
    self.lab2.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary* d = NSDictionaryOfVariableBindings(_lab1, _lab2);

    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-[_lab1]"
      options:0 metrics:nil views:d]];
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-[_lab2]"
      options:0 metrics:nil views:d]];
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-20-[_lab1]"
      options:0 metrics:nil views:d]];
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[_lab2]-20-|"
      options:0 metrics:nil views:d]];
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[_lab1]-(>=20)-[_lab2]"
      options:0 metrics:nil views:d]];
    
    // we will be ambiguous when the label texts grow
    // one way to solve: different compression resistance priorities
    
    [self.lab1 setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    
    // ======================================
    
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    
    d = NSDictionaryOfVariableBindings(_button,_label);
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[_button]-(112)-|"
      options:0 metrics:nil views:d]];
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-(>=10)-[_label]-[_button]-(>=10)-|"
      options:NSLayoutFormatAlignAllBaseline metrics:nil views:d]];
    NSLayoutConstraint* con =
    [NSLayoutConstraint
     constraintWithItem:_button attribute:NSLayoutAttributeCenterX
     relatedBy:0
     toItem:self.view attribute:NSLayoutAttributeCenterX
     multiplier:1 constant:0];
    con.priority = 700; // try commenting this out to see the difference in behavior
    [self.view addConstraint:con];

    
}


@end
