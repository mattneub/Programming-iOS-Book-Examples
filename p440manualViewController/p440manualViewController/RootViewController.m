

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
            UIView* v = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
            v.backgroundColor = [UIColor greenColor];
            UILabel* label = [[UILabel alloc] init];
            label.text = @"Hello, World!";
            [label sizeToFit];
            label.center = CGPointMake(CGRectGetMidX(v.bounds), CGRectGetMidY(v.bounds));
            label.autoresizingMask = (
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleBottomMargin |
                                      UIViewAutoresizingFlexibleRightMargin
                                      );
            [v addSubview:label];
            self.view = v;
            [label release];
            [v release];
            break;
        }
        case 2:
        {
            // construct view partially in code, fetch some of it from a nib
            UIView* v = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
            v.backgroundColor = [UIColor yellowColor];
            [[NSBundle mainBundle] loadNibNamed: @"MyNib" owner:self options:nil];
            self.theLabel.center = CGPointMake(CGRectGetMidX(v.bounds), CGRectGetMidY(v.bounds));
            [v addSubview:self.theLabel];
            self.view = v;
            [v release];
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
        case 3:
        {
            // p 445: no need for us to alloc and release the view and assign it to self.view;
            // if we do nothing loadView, it's done for us
            self.view.backgroundColor = [UIColor redColor];
            [[NSBundle mainBundle] loadNibNamed: @"MyNib" owner:self options:nil];
            self.theLabel.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
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
