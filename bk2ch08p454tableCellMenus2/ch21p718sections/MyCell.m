

#import "MyCell.h"

@implementation MyCell

-(void)abbrev:(id)sender {
    // find my table view
    UIView* v = self;
    do {
        v = v.superview;
    } while (![v isKindOfClass:[UITableView class]]);
    UITableView* tv = (UITableView*) v;
    // ask it what index path we are
    NSIndexPath* ip = [tv indexPathForCell:self];
    // talk to its delegate
    if (tv.delegate && [tv.delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)])
        [tv.delegate tableView:tv performAction:_cmd forRowAtIndexPath:ip withSender:sender];
}

@end
