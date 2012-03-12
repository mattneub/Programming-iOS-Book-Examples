

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface ViewController : UIViewController  <UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource>

- (void) displayPDF: (NSURL*) url;

@end
