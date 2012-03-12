

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) IBOutlet UITabBar *tb;
@property (nonatomic, copy) NSArray* items;
@end

@implementation RootViewController
@synthesize tb, items;


- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray* arr = [NSMutableArray array];
    for (int ix = 1; ix < 8; ix++) {
        UITabBarItem* tbi = 
        [[UITabBarItem alloc] initWithTabBarSystemItem:ix tag:ix];
        [arr addObject: tbi];
    }
    self.items = arr; // copy policy
    [arr removeAllObjects];
    [arr addObjectsFromArray: [self.items subarrayWithRange:NSMakeRange(0,4)]];
    UITabBarItem* tbi = [[UITabBarItem alloc] initWithTabBarSystemItem:0 tag:0];
    [arr addObject: tbi]; // More button
    tb.items = arr; // tb is the UITabBar
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"did select item with tag %i", item.tag);
    if (item.tag == 0) {
        // More button
        tabBar.selectedItem = nil;
        [tabBar beginCustomizingItems:self.items];
    }
}


@end
