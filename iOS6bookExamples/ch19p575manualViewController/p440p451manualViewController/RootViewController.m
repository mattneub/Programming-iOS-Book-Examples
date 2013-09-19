

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) IBOutlet UILabel* theLabel;
@end

@implementation RootViewController

#pragma mark - View lifecycle

#define which 2 // try also "2" and "3" and "4"

- (void) loadView {
    switch (which) {
        case 1:
        {
            // construct view entirely in code
            UIView* v = [UIView new];
            v.backgroundColor = [UIColor greenColor];
            self.view = v;
            UILabel* label = [UILabel new];
            [v addSubview:label];
            label.text = @"Hello, World!";
            
            label.autoresizingMask = (
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleBottomMargin |
                                      UIViewAutoresizingFlexibleRightMargin
                                      );
            [label sizeToFit];
            label.center = CGPointMake(CGRectGetMidX(v.bounds), CGRectGetMidY(v.bounds));
            label.frame = CGRectIntegral(label.frame); // added this to prevent initial fuzzies
            break;
        }
        case 2: // same as case 1 but using constraints
        {
            // construct view entirely in code
            UIView* v = [UIView new];
            v.backgroundColor = [UIColor greenColor];
            self.view = v;
            UILabel* label = [UILabel new];
            [v addSubview:label];
            label.text = @"Hello, World!";
            
            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addConstraint:
             [NSLayoutConstraint
              constraintWithItem:label attribute:NSLayoutAttributeCenterX
              relatedBy:0
              toItem:self.view attribute:NSLayoutAttributeCenterX
              multiplier:1 constant:0]];
            [self.view addConstraint:
             [NSLayoutConstraint
              constraintWithItem:label attribute:NSLayoutAttributeCenterY
              relatedBy:0
              toItem:self.view attribute:NSLayoutAttributeCenterY
              multiplier:1 constant:0]];
            break;
        }
        case 3:
        {
            // construct view partially in code, fetch some of it from a nib
            // in the 2nd edition of the book, skipped this example
            UIView* v = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
            v.backgroundColor = [UIColor yellowColor];
            [[NSBundle mainBundle] loadNibNamed: @"MyNib" owner:self options:nil];
            self.theLabel.center = CGPointMake(CGRectGetMidX(v.bounds), CGRectGetMidY(v.bounds));
            self.theLabel.frame = CGRectIntegral(self.theLabel.frame); // added this to prevent initial fuzzies
            [v addSubview:self.theLabel];
            self.view = v;
            break;
        }
        case 4:
        {
            [super loadView]; // just to prevent recursion
            break;
        }
    }
}

-(void)viewDidLoad {
    switch (which) {
        case 1:
        case 2:
        case 3:
        {
            break;
        }
        case 4:
        {
            // no need for us to alloc-init the view and assign it to self.view;
            // if we do nothing in loadView, it's done for us
            // rest is like case 3
            // in the 2nd edition of the book, skipped this example
            self.view.backgroundColor = [UIColor redColor];
            [[NSBundle mainBundle] loadNibNamed: @"MyNib" owner:self options:nil];
            self.theLabel.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
            self.theLabel.frame = CGRectIntegral(self.theLabel.frame); // added this to prevent initial fuzzies
            [self.view addSubview:self.theLabel];
            break;
        }
    }
}

/*
 NB Rotate the device to prove that the view controller is doing something useful.
 
 The big change in iOS is that this next method is completely ineffective!
 We are never even consulted. Instead, the Info.plist settings
 UISupportedInterfaceOrientations are taken seriously,
 and we can filter these with supportedInterfaceOrientations.
 
 Note that the documentation still gets this wrong, implying that to launch into a particular
 orientation you can also supply UIInterfaceOrientation. This is wrong.
 You will launch into the *first* of the supplied UISupportedInterfaceOrientations.
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"this message never appears");
    return YES;
}


@end
