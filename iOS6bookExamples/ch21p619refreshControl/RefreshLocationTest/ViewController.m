

#import "ViewController.h"

@interface ViewController () <UISearchBarDelegate>

@end

@implementation ViewController

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
