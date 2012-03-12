

#import "RootViewController.h"


@implementation RootViewController
@synthesize theLabel;

#pragma mark - View lifecycle

#define which 1 // try also "2" and "3"

- (void) loadView {
    switch (which) {
        case 1:
        {
            // construct view entirely in code
            UIView* v = [[UIView alloc] init];
            v.backgroundColor = [UIColor greenColor];
            self.view = v;
            UILabel* label = [[UILabel alloc] init];
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
        case 2:
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
        case 3:
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
        {
            break;
        }
        case 3:
        {
            // p 445: no need for us to alloc-init the view and assign it to self.view;
            // if we do nothing in loadView, it's done for us
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



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES; // rotation proves that the view controller is really doing something useful
}

@end
