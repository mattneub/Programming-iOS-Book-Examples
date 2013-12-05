

#import "AppDelegate.h"
#import "MyClass.h"

@implementation AppDelegate {
    MyClass* _thing;
    id _obj;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UINavigationController* nav = [[UINavigationController alloc] init];
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    self->_obj = [NSObject new];
    
    nav.delegate = self->_obj; // non-ARC weak reference
    
    MyClass* m = [MyClass new];
    m.delegate = self->_obj; // ARC weak reference
    
    self->_thing = m; // retain
    
    
    // Okay, so we now have two references to the object at self->_obj:
    // a non-ARC weak reference and an ARC weak reference
    
    // confirm this
    NSLog(@"MyClass delegate (1): %@", _thing.delegate); //
    NSLog(@"Nav Controller delegate (1): %@", ((UINavigationController*)self.window.rootViewController).delegate); //
    
    // get off this transaction, give autorelease pool a chance to drain etc.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // cry havoc, and let slip the dogs of war!
        self->_obj = nil; // releases obj - now what is nav.delegate pointing to??
        
        NSLog(@"MyClass delegate (2): %@", _thing.delegate); // perfectly safe, __weak ref is nilified
        NSLog(@"Nav Controller delegate (2): %@", ((UINavigationController*)self.window.rootViewController).delegate); // if you're lucky it might print something!
        // or more likely it will just crash, or maybe print and *then* crash
        // good chance to turn on Zombies so you can see this happen "nicely"
    });

    
    
    
    return YES;
}


@end
