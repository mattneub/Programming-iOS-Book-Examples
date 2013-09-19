

#import "FirstViewController.h"
#import "SecondViewController.h"
#import <objc/objc-runtime.h>

@interface FirstViewController () <SVCDelegate>

@end

@implementation FirstViewController

- (IBAction)doPresent:(id)sender {
    SecondViewController* svc = [SecondViewController new];
    svc.delegate = self;
    [self presentViewController:svc animated:YES completion:nil];
}

// this is the secret sauce
// so what this demonstrates is that dismissViewControllerAnimated: is turned
// behind the scenes into the undocumented dismissViewControllerWithTransition
// and it is this that is passed up successively to the presenting view controller

- (void) dismissViewControllerWithTransition: (int) t completion:(void (^)(void))completion {
    NSLog(@"fvc %@", @"ha");
    struct objc_super sup = {self, class_getSuperclass([self class])};
    objc_msgSendSuper(&sup, @selector(dismissViewControllerWithTransition:completion:), t, completion);
}

- (void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    NSLog(@"%@", @"fvc dismiss");
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (void) dismissMe {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							

@end
