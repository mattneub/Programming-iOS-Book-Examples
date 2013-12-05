

#import <Foundation/Foundation.h>

@interface MyDataSource : NSObject <UITableViewDataSource>
@property (nonatomic, strong) NSObject <UITableViewDataSource> *originalDataSource;
@end
