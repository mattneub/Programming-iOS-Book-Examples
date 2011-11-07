

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize v;

#define which 1 // try "2" thru "6" for further examples

- (void) animate {
    switch (which) {
        case 1:
        {
            // p 362
            [UIView beginAnimations:nil context:NULL];
            v.backgroundColor = [UIColor yellowColor];
            CGPoint p = v.center;
            p.y -= 100;
            v.center = p;
            [UIView commitAnimations];
            break;
        }
        case 2:
        {
            // p 364, jump
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationRepeatAutoreverses:YES];
            CGPoint p = v.center;
            p.x += 100;
            v.center = p;
            [UIView commitAnimations];
            break;
        }
        case 3:
        {
            // p 365, failed solution
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationRepeatAutoreverses:YES];
            CGPoint p = v.center;
            p.x += 100;
            v.center = p;
            [UIView commitAnimations];
            p = v.center;
            p.x -= 100;
            v.center = p;
            break;
        }
        case 4:
        {
            // p 365, successful solution
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationRepeatAutoreverses:YES];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(stopped:fin:context:)];
            CGPoint p = v.center;
            p.x += 100;
            v.center = p;
            [UIView commitAnimations];
            break;
        }
        case 5:
        {
            // p 366
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1];
            CGPoint p = v.center;
            p.x += 100;
            v.center = p;
            [UIView commitAnimations];
            
            [UIView beginAnimations:nil context:NULL];
            // uncomment the next line to fix the problem
            // [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:1];
            CGPoint p2 = v.center;
            p2.x = 0; // and try changing x to y
            v.center = p2;
            [UIView commitAnimations];
            break;
        }
        case 6:
        {
            // p 369, same as case 4 but using block-based solution (and no need for delegate)
            CGPoint p = v.center;
            CGPoint pOrig = p;
            p.x += 100;
            void (^anim) (void) = ^{
                v.center = p;
            };
            void (^after) (BOOL) = ^(BOOL f) {
                v.center = pOrig;
            };
            NSUInteger opts = UIViewAnimationOptionAutoreverse;
            [UIView animateWithDuration:1 delay:0 options:opts 
                             animations:anim completion:after];
            break;
        }
    }
}

- (void) stopped:(NSString *)anim fin:(NSNumber*)fin context:(void *)context {
    CGPoint p = v.center;
    p.x -= 100;
    v.center = p;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.v = [[UIView alloc] initWithFrame:CGRectMake(58,255,204,204)];
    v.backgroundColor = [UIColor redColor];
    [self.window.rootViewController.view addSubview: v];
    [self.window makeKeyAndVisible];
    [self performSelector:@selector(animate) withObject:nil afterDelay:1.0];

    return YES;
}

@end
