

#import "AppDelegate.h"

@interface AppDelegate ()
@property (strong, nonatomic) UIView *v;
@end

@implementation AppDelegate

#define which 1 // try "2" thru "6" for further examples

- (void) animate {
    switch (which) {
        case 1:
        {
            // p 475
            [UIView beginAnimations:nil context:nil];
            _v.backgroundColor = [UIColor yellowColor];
            CGPoint p = _v.center;
            p.y -= 100;
            _v.center = p;
            [UIView commitAnimations];
            break;
        }
        case 2:
        {
            // p 478, jump
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationRepeatAutoreverses:YES];
            CGPoint p = _v.center;
            p.x += 100;
            _v.center = p;
            [UIView commitAnimations];
            break;
        }
        case 3:
        {
            // p 478, failed solution
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationRepeatAutoreverses:YES];
            CGPoint p = _v.center;
            p.x += 100;
            _v.center = p;
            [UIView commitAnimations];
            p = _v.center;
            p.x -= 100;
            _v.center = p;
            break;
        }
        case 4:
        {
            // p 478, successful solution
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationRepeatAutoreverses:YES];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(stopped:fin:context:)];
            CGPoint p = _v.center;
            p.x += 100;
            _v.center = p;
            [UIView commitAnimations];
            break;
        }
        case 5:
        {
            // p 479
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            CGPoint p = _v.center;
            p.x += 100;
            _v.center = p;
            [UIView commitAnimations];
            
            [UIView beginAnimations:nil context:nil];
            // uncomment the next line to fix the problem
            // [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:1];
            CGPoint p2 = _v.center;
            p2.x = 0; // and try changing x to y
            _v.center = p2;
            [UIView commitAnimations];
            break;
        }
        case 6:
        {
            // p 483, same as case 4 but using block-based solution (and no need for delegate)
            CGPoint p = _v.center;
            CGPoint pOrig = p;
            p.x += 100;
            void (^anim) (void) = ^{
                _v.center = p;
            };
            void (^after) (BOOL) = ^(BOOL f) {
                _v.center = pOrig;
            };
            NSUInteger opts = UIViewAnimationOptionAutoreverse;
            [UIView animateWithDuration:1 delay:0 options:opts 
                             animations:anim completion:after];
            break;
        }
    }
}

- (void) stopped:(NSString *)anim fin:(NSNumber*)fin context:(void *)context {
    CGPoint p = _v.center;
    p.x -= 100;
    _v.center = p;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.v = [[UIView alloc] initWithFrame:CGRectMake(58,255,204,204)];
    _v.backgroundColor = [UIColor redColor];
    [self.window.rootViewController.view addSubview: _v];
    [self.window makeKeyAndVisible];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self animate];
    });

    return YES;
}

@end
