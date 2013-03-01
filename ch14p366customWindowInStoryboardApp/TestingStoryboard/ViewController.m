

#import "ViewController.h"

@implementation ViewController

- (IBAction)doButton:(id)sender {
    // ways of referring to the window
    NSLog(@"%@", [((UIView*)sender).window class]); // cast needed by ARC
    NSLog(@"%@", [[[[UIApplication sharedApplication] delegate] window] class]);
    NSLog(@"%@", [[[UIApplication sharedApplication] keyWindow] class]);
}

@end
