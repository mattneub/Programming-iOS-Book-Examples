
#import "MyDataSource.h"


@implementation MyDataSource
@synthesize originalDataSource;

// this is how you would have had to do it before iOS 4
/*
- (BOOL)respondsToSelector:(SEL)aSelector {
    NSLog(@"responds %@", NSStringFromSelector(aSelector));
    if ([super respondsToSelector:aSelector])
        return YES;
    else if ([self.originalDataSource respondsToSelector:aSelector])
        return YES;
    return NO;
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
    NSLog(@"meth %@", NSStringFromSelector(selector));
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature)
        signature = [self.originalDataSource methodSignatureForSelector:selector];
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"forward %@", NSStringFromSelector([anInvocation selector]));
    if ([self.originalDataSource respondsToSelector: [anInvocation selector]])
        [anInvocation invokeWithTarget:self.originalDataSource];
    else
        [super forwardInvocation:anInvocation];
}
 */

// new fast way of forwarding

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
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}



@end
