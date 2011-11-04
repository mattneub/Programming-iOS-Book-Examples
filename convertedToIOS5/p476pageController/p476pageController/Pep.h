
#import <UIKit/UIKit.h>

@interface Pep : UIViewController

- (id) initWithPepBoy: (NSString*) inputboy;

@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UIImageView* pic;

@property (nonatomic, copy) NSString* boy;

@end
