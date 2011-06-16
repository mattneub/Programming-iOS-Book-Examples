

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <UITextFieldDelegate> {

}
@property (nonatomic, copy) NSString* name;
@property (nonatomic, retain) NSMutableArray* numbers;
@property (nonatomic, assign) IBOutlet UITableViewCell* aCell;


@end
