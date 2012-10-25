
#import <UIKit/UIKit.h>

@interface Pep : UIViewController <UIViewControllerRestoration>

- (id) initWithPepBoy: (NSString*) boy nib: (NSString*) nib bundle: (NSBundle*) bundle;

@property (nonatomic, copy) NSString* boy;

@end
