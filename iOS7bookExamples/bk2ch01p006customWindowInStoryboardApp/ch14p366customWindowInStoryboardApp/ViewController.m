

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%@", [self.view.window class]);
    NSLog(@"%@", [[[[UIApplication sharedApplication] delegate] window] class]);
    NSLog(@"%@", [[[UIApplication sharedApplication] keyWindow] class]);

}

@end
