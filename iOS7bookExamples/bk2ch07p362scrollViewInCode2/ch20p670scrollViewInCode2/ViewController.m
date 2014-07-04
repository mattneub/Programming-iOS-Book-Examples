

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIScrollView* sv = [UIScrollView new];
    // sv.alwaysBounceHorizontal = YES;
    sv.backgroundColor = [UIColor whiteColor];
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
        // lab.backgroundColor = [UIColor redColor];
        lab.translatesAutoresizingMaskIntoConstraints = NO;
        lab.text = [NSString stringWithFormat:@"This is label %d", i+1];
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
             [NSLayoutConstraint
              constraintsWithVisualFormat:@"V:[prev]-(10)-[lab]"
              options:0 metrics:nil
              views:@{@"lab":lab, @"prev":previousLab}]];
        }
        previousLab = lab;
    }
    
    // last one, pin to bottom, this dictates content size height
    [sv addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lab]-(10)-|"
                                             options:0 metrics:nil
                                               views:@{@"lab":previousLab}]];
}




@end
