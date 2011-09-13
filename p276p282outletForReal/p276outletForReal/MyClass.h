

#import <Foundation/Foundation.h>


@interface MyClass : NSObject {
}
// this is what memory management for an outlet will typically *really* look like
@property (nonatomic, retain) IBOutlet UILabel* theLabel;


@end
