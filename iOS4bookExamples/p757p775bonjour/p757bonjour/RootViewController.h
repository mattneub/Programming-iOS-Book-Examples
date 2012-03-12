

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <NSNetServiceBrowserDelegate, NSNetServiceDelegate> {
    
}
@property (nonatomic, retain) NSNetServiceBrowser* nsb;
@property (nonatomic, retain) NSMutableArray* services;

@end
