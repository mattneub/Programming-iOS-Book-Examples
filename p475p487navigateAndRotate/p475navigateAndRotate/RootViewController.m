

#import "RootViewController.h"
#import "SecondViewController.h"

@implementation RootViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Root";
}

// cute hack to force rotation as we navigate in a navigation interface, by using a modal view
// this hack is pretty skanky; I'm not sure I can really recommend it

- (void) doButton: (id) sender {
    SecondViewController* sec = [[SecondViewController alloc] init];
    sec.title = self.title; // to give the correct back button title
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:sec];
    SecondViewController* sec2 = [[SecondViewController alloc] init];
    [nav pushViewController:sec2 animated:NO];
    [self presentModalViewController:nav animated:YES];
    nav.delegate = self; // so that we know when the user navigates back
    [sec release]; [sec2 release]; [nav release];
}

// and here's the delegate method
- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController 
                    animated:(BOOL)animated {
    if (viewController == [navigationController.viewControllers objectAtIndex:0])
        [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
