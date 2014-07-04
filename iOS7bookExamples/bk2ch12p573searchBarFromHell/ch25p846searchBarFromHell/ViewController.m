
#import "ViewController.h"

@interface ViewController () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *sb;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.sb.searchBarStyle = UISearchBarStyleDefault;
    self.sb.barStyle = UIBarStyleDefault;
    self.sb.translucent = YES;
    self.sb.barTintColor = [UIColor greenColor]; // unseen in this example
    // self.sb.backgroundColor = [UIColor redColor];
    
    UIImage* im = [UIImage imageNamed:@"linen.png"];
    im = [im resizableImageWithCapInsets:UIEdgeInsetsMake(1,1,1,1) resizingMode:UIImageResizingModeStretch];
    [self.sb setBackgroundImage:im forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.sb setBackgroundImage:im forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefaultPrompt];
    
    im = [UIImage imageNamed:@"sepia.jpg"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320,20), NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(5,0,320-5*2,20) cornerRadius:5] addClip];
    [im drawInRect:CGRectMake(0,0,320,20)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.sb setSearchFieldBackgroundImage:im forState:UIControlStateNormal];
    // just to show what it does:
    self.sb.searchFieldBackgroundPositionAdjustment = UIOffsetMake(0, -10);
    
    // how to reach in and grab the text field
    for (UIView* v in [self.sb.subviews[0] subviews]) {
        if ([v isKindOfClass: [UITextField class]]) {
            UITextField* tf = (UITextField*)v;
            tf.textColor = [UIColor whiteColor];
            break;
        }
    }
    
    self.sb.text = @"Search me!";
    //    self.sb.showsBookmarkButton = YES;
    //    self.sb.showsSearchResultsButton = YES;
    //    self.sb.searchResultsButtonSelected = YES;
    
    im = [UIImage imageNamed:@"manny.jpg"];
    [self.sb setImage:im forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20,20), YES, 0);
    [im drawInRect:CGRectMake(0,0,20,20)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.sb setImage:im forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    
    im = [UIImage imageNamed:@"moe.jpg"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20,20), YES, 0);
    [im drawInRect:CGRectMake(0,0,20,20)];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.sb setImage:im forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
    
    self.sb.showsScopeBar = YES;
    self.sb.scopeButtonTitles = @[@"Manny", @"Moe", @"Jack"];
    
    self.sb.scopeBarBackgroundImage = [UIImage imageNamed:@"sepia.jpg"];
    
    im = [UIImage imageNamed:@"linen.png"];
    im = [im resizableImageWithCapInsets:UIEdgeInsetsMake(1,1,1,1) resizingMode:UIImageResizingModeStretch];
    [self.sb setScopeBarButtonBackgroundImage:im forState:UIControlStateNormal];
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(2,2), YES, 0);
    [[UIColor whiteColor] setFill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0,0,2,2)] fill];
    im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.sb setScopeBarButtonDividerImage:im forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal];
    
    NSShadow* shad = [NSShadow new];
    shad.shadowColor = [UIColor grayColor];
    shad.shadowOffset = CGSizeMake(2,2);
    NSDictionary* atts = @{
                           NSFontAttributeName:[UIFont fontWithName:@"GillSans-Bold" size:16],
                           NSForegroundColorAttributeName: [UIColor whiteColor],
                           NSShadowAttributeName: shad,
                           NSUnderlineStyleAttributeName: @(NSUnderlineStyleDouble)
                           };
    [self.sb setScopeBarButtonTitleTextAttributes:atts forState:UIControlStateNormal];
    [self.sb setScopeBarButtonTitleTextAttributes:atts forState:UIControlStateSelected];

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


@end
