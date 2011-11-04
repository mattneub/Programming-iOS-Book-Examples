

#import "ViewController.h"
#import "MyClass.h"

@implementation ViewController


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // prove that a storyboard assigns the window's rootViewController
    NSLog(@"rootViewController: %@", self.view.window.rootViewController);
    // prove that we "have" a storyboard (the storyboard that instantiated us)
    NSLog(@"storyboard: %@", self.storyboard);

}


// It is also possible to "dive" into a storyboard and bring a controller-scene pair into existence
// This happens automatically when you segue to a scene...
// but you might want to do it manually
- (IBAction)doButton:(id)sender {
    // this is like [[MyClass alloc] init] along with loading of the corresponding nib
    // in this case, though, there is no nib; there's a "scene" in the storyboard, with an identifier
    MyClass* m = [self.storyboard instantiateViewControllerWithIdentifier:@"secondView"];
    
    // to prove that this worked, I'll grab the label from m's outlet and stick it in our interface
    // this is a very weird and artifical thing to do, but it does show that you can use storyboard instead of nibs
    
    // trick to force the view controller to load its view; I *told* you this was weird
    // (the problem is that they won't let me use a non-UIViewController as owner of a storyboard scene)
    UIView* v __attribute__((unused)) = m.view; // quiet the overly smart compiler
    
    UILabel* lab = m.theLabel;
    [self.view addSubview: lab];

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [lab removeFromSuperview];
    });
}


@end
