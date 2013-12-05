
#import "MyDataSource.h"


@implementation MyDataSource

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.originalDataSource respondsToSelector: aSelector])
        return self.originalDataSource;
    return [super forwardingTargetForSelector:aSelector];
}


- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)sec {
    // this is just to quiet the compiler
    return [self.originalDataSource tableView:tv numberOfRowsInSection:sec];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell* cell = [self.originalDataSource tableView:tv cellForRowAtIndexPath:ip];
    cell.textLabel.font = [UIFont fontWithName:@"GillSans-Bold" size:14];
    return cell;
}



@end
