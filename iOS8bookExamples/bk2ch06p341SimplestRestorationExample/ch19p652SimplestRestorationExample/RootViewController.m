
#import "RootViewController.h"
#import "SecondViewController.h"

@interface RootViewController () 

@end

@implementation RootViewController


- (IBAction) unwind: (UIStoryboardSegue*) s {
    
}

// prove that the segue is not magically called during restoration

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", segue.identifier);
}

@end
