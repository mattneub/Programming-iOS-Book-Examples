

#import <Foundation/Foundation.h>


@interface MyClass : NSObject {
    IBOutlet UILabel* theLabel;
}
// memory management, even though we haven't discussed this yet; see warning on p. 263
@property (nonatomic, assign) UILabel* theLabel;


@end
