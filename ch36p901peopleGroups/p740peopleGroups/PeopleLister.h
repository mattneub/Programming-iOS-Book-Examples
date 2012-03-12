

#import <UIKit/UIKit.h>

@interface PeopleLister : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil fileURL: (NSURL*) fileURL;

@end
