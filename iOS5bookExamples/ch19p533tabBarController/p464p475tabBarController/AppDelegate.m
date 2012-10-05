

#import "AppDelegate.h"
#import "View1Controller.h"
#import "View2Controller.h"


@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    UITabBarController* tbc = [[UITabBarController alloc] init];
    View1Controller* v1c = [[View1Controller alloc] init];
    View2Controller* v2c = [[View2Controller alloc] init];
    [tbc setViewControllers:[NSArray arrayWithObjects:v1c, v2c, nil] animated:NO];
        
    self.window.rootViewController = tbc;
    // easy to make tab bar controller interface via code
    // do note, however, that you can also do via nib, and especially that you can do it via storyboard
    // storyboard is a very good option here, because each contained view could have its own series of segues
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // comment out the next line if you want to play with new iOS 5 color customizations
    // return YES;
    
    // new iOS 5 feature! color color everywhere
    [tbc.tabBar setTintColor:[UIColor redColor]]; 
    [tbc.tabBar setSelectedImageTintColor:[UIColor greenColor]];
    
    // new iOS 5 feature! set your own selection indicator instead of the rectangular gradient
    CGSize sz = {50,tbc.tabBar.bounds.size.height};
    UIGraphicsBeginImageContext(sz);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), 
                                   [UIColor colorWithWhite:0.3 alpha:0.3].CGColor);
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:
                       CGRectMake(0,0,sz.width,sz.height-10)];
    [p fill];
    [tbc.tabBar setSelectionIndicatorImage:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    
    // new iOS 5 feature! text attributes for bar items
    // could do this with each tabBarItem individually...
    // but can also do it universally by passing thru appearance proxy
    [[UITabBarItem appearance] setTitleTextAttributes: 
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor],
      UITextAttributeTextColor,
      // NB UIOffset and its NSValue wrapper are new in iOS 5
      // instead of misusing CGSize or CGPoint to represent an offset value pair
      [NSValue valueWithUIOffset:UIOffsetMake(2,2)],
      UITextAttributeTextShadowOffset,
      // you won't see any shadow unless you set the color
      [UIColor colorWithWhite:.2 alpha:.4],
      UITextAttributeTextShadowColor,
      nil]
                                             forState:UIControlStateNormal];

    
    // new iOS 5 feature! add background image (could even be [uck] an animated image)
    // overrides tint color, set above
    // however, the tint color does still come through for the unselected tab bar item image
    // comment out next line to see it
    return YES;
    UIImage* lin = [UIImage imageNamed:@"linen.png"];
    CGSize sz2 = tbc.tabBar.frame.size;
    sz2.height +=5;
    UIGraphicsBeginImageContext(sz2);
    [lin drawInRect:(CGRect){{0,0},sz2}];
    // rotate the app to see the problem here:
    // if we don't make a resizable image, the whole image will be tiled
    // our image is not particularly tilable in that way, so we make it tile its middle instead
    [tbc.tabBar setBackgroundImage:
     [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets:
      UIEdgeInsetsMake(0, sz2.width/2.0-20, 0, sz2.width/2.0-20)]];
    UIGraphicsEndImageContext();
    
    // in the actual book, however, I think I'd postpone discussion of all this to the Controls chapter
    
    return YES;
}

@end
