

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {

}
@property (nonatomic, retain) UISearchDisplayController* sbc;
@property (nonatomic, retain) NSArray* states;
@property (nonatomic, retain) NSArray* filteredStates;
@property (nonatomic, retain) NSMutableArray* sectionNames;
@property (nonatomic, retain) NSMutableArray* sectionData;

@end
