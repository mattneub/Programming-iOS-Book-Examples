

#import "ViewController.h"

@interface ViewController () <UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property (nonatomic, copy) NSArray* items;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray* arr = [NSMutableArray new];
    for (int ix = 1; ix < 8; ix++) {
        UITabBarItem* tbi =
        [[UITabBarItem alloc] initWithTabBarSystemItem:ix tag:ix];
        [arr addObject: tbi];
    }
    self.items = arr; // copy policy
    [arr removeAllObjects];
    [arr addObjectsFromArray: [self.items subarrayWithRange:NSMakeRange(0,4)]];
    UITabBarItem* tbi =
    [[UITabBarItem alloc] initWithTabBarSystemItem:0 tag:0];
    [arr addObject: tbi]; // More button
    self.tabbar.items = arr;
    
    self.tabbar.selectedItem = self.tabbar.items[0];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"did select item with tag %ld", (long)item.tag);
    if (item.tag == 0) {
        // More button
        tabBar.selectedItem = nil;
        [tabBar beginCustomizingItems:self.items];
    }
}

-(void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed {
    self.tabbar.selectedItem = self.tabbar.items[0];
}


@end
