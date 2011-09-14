

#import <Foundation/Foundation.h>


@interface MyDataSource : NSObject <UITableViewDataSource> {

}
@property (nonatomic, retain) NSObject <UITableViewDataSource> *originalDataSource;
@end
