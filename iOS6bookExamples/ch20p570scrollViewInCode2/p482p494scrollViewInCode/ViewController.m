

#import "ViewController.h"

@implementation ViewController

#define which 1 // try "2" and rotate the app

/*
 
 Auto layout variant of previous example
 
 Constraints dictate content size!
 
 */

// do not implement loadView; allow runtime to generate generic view

- (void) viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView* sv = [UIScrollView new];
    sv.backgroundColor = [UIColor whiteColor]; // default is black for new view
    sv.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:sv];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[sv]|"
                                             options:0 metrics:nil
                                               views:@{@"sv":sv}]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[sv]|"
                                             options:0 metrics:nil
                                               views:@{@"sv":sv}]];

    UILabel* previousLab = nil;
    for (int i=0; i<30; i++) {
        UILabel* lab = [UILabel new];
        lab.translatesAutoresizingMaskIntoConstraints = NO;
        lab.text = [NSString stringWithFormat:@"This is label %i", i+1];
        [sv addSubview:lab];
                
        [sv addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[lab]"
                                                 options:0 metrics:nil
                                                   views:@{@"lab":lab}]];
        if (!previousLab) { // first one, pin to top
            [sv addConstraints:
             [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[lab]"
                                                     options:0 metrics:nil
                                                       views:@{@"lab":lab}]];
        } else { // all others, pin to previous
            [sv addConstraints:
             [NSLayoutConstraint constraintsWithVisualFormat:@"V:[prev]-(10)-[lab]"
                                                     options:0 metrics:nil
                                                       views:@{@"lab":lab, @"prev":previousLab}]];
        }
        previousLab = lab;
        
        switch (which) {
            case 1:
                break;
            case 2:
                lab.backgroundColor = [UIColor redColor]; // make label bounds visible
                break;
        }
    }
    // last one, pin to bottom and right, this dictates content size height
    [sv addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lab]-(10)-|"
                                             options:0 metrics:nil
                                               views:@{@"lab":previousLab}]];
    [sv addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[lab]-(10)-|"
                                             options:0 metrics:nil
                                               views:@{@"lab":previousLab}]];
    
    // look, Ma, no contentSize!
}

-(NSUInteger)supportedInterfaceOrientations {
    NSUInteger result = UIInterfaceOrientationMaskPortrait;
    switch (which) {
        case 1:
            break;
        case 2:
            result = UIInterfaceOrientationMaskAll;
    }
    return result;
}


@end
