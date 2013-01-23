//
//  ExtraViewController.m
//  p550p565popovers
//
//  Created by Matt Neuburg on 1/22/13.
//
//

#import "ExtraViewController.h"

@interface ExtraViewController ()

@end

@implementation ExtraViewController
- (IBAction)doButton:(id)sender {
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.contentSizeForViewInPopover = CGSizeMake(320,220);
        // self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0,0,320,220);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    NSLog(@"%@", @"dealloc");
}

@end
