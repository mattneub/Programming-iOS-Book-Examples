

#import "MyCell.h"

@implementation MyCell

-(void)abbrev:(id)sender {
    NSLog(@"cell was told to abbrev %@", sender);
    if (self.celldelegate) {
        if ([self.celldelegate respondsToSelector:
             @selector(tableView:performAction:forRowAtIndexPath:withSender:)]) {
            // find my table view
            UIView* v = self;
            do {
                v = v.superview;
            } while (![v isKindOfClass:[UITableView class]]);
            UITableView* tv = (UITableView*) v;
            // ask it what index path we are
            NSIndexPath* ip = [tv indexPathForCell:self];
            // pretend to be the delegate
            [self.celldelegate tableView:tv performAction:_cmd forRowAtIndexPath:ip withSender:sender];
        }
    }
}


@end
