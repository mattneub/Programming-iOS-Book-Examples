

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface RootViewController : UIViewController <UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource> {
    
    UIWebView *wv;
    UIButton *b;
}
- (void) displayPDF: (NSURL*) url;
@property (nonatomic, retain) IBOutlet UIWebView *wv;
@property (nonatomic, retain) IBOutlet UIButton *b;
@property (nonatomic, retain) NSURL* pdf;
@property (nonatomic, copy) NSArray* pdfs;
@property (nonatomic, retain) UIDocumentInteractionController* dic;

@end
