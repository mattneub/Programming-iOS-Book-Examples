
#import <UIKit/UIKit.h>

@interface Pep : UIViewController

- (id) initWithPepBoy: (NSString*) boy nib: (NSString*) nib bundle: (NSBundle*) bundle;

@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UIImageView* pic;

@property (nonatomic, copy) NSString* boy;

@end
