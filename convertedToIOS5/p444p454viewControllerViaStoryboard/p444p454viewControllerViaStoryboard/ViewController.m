

#import "ViewController.h"

@implementation ViewController


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // prove that a storyboard assigns the window's rootViewController
    NSLog(@"%@", self.view.window.rootViewController);
}

@end
