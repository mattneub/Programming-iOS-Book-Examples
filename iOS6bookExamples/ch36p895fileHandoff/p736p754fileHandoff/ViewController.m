

#import "ViewController.h"
#import <QuickLook/QuickLook.h>

@interface ViewController () <UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource>

@property (nonatomic, weak) IBOutlet UIWebView *wv;
@property (nonatomic, weak) IBOutlet UIButton *b;
@property (nonatomic, weak) IBOutlet UIButton *b2;
@property (nonatomic, strong) NSURL* pdf;
@property (nonatomic, copy) NSArray* pdfs;
@property (nonatomic, strong) UIDocumentInteractionController* dic;
@end

@implementation ViewController

- (void)dealloc
{
    [self->_wv stopLoading];
    [self->_wv setDelegate: nil];
}

// run on device

// first, use some other application, such as DropBox or GoodReader...
// to hand off a pdf to this application

- (void) displayPDF: (NSURL*) url {
    self.pdf = url;
    self.dic = [UIDocumentInteractionController interactionControllerWithURL:url];
    UIImage* icon = self.dic.icons[0];
    [self.b setImage:icon forState:UIControlStateNormal];
    self.b.enabled = YES;
    
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    [self.wv loadRequest:req];
}

// then tap the Preview button to try previewing...
// and perhaps handing the currently showing PDF to another application

- (IBAction)doButton:(id)sender {
    if (!self.pdf)
        return;
    
    
//    self.dic = [UIDocumentInteractionController interactionControllerWithURL:self.pdf];
//    BOOL y =
//    [self.dic presentOptionsMenuFromRect:[sender bounds]
//                             inView:sender animated:YES];
//  BOOL y = [self.dic presentOpenInMenuFromRect:[sender bounds] inView:sender animated:YES];
//    return;
    
    
    self.dic.delegate = self;
    [self.dic presentPreviewAnimated:YES];
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: 
(UIDocumentInteractionController *) controller {
    return self;
}

// if you've handed several PDFs to this app...
// this next button will display previews for all of them

- (IBAction)doButton2:(id)sender {
    // obtain URLs of PDFs as an array
    NSFileManager* fm = [NSFileManager new];
    NSURL* docsurl = [fm URLForDirectory:NSDocumentDirectory 
                                inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSDirectoryEnumerator* dir = [fm enumeratorAtURL:[docsurl URLByAppendingPathComponent:@"Inbox"] includingPropertiesForKeys:nil options:0 errorHandler:nil];
    if (!dir)
        return; // proper error-checking omitted
    NSMutableArray* marr = [NSMutableArray array];
    for (NSURL* f in dir) {
        [dir skipDescendants];
        if ([[f pathExtension] isEqualToString: @"pdf"])
            [marr addObject: f];
    }
    self.pdfs = marr; // retain policy
    if (![self.pdfs count])
        return;
    // show preview interface
    QLPreviewController* preview = [QLPreviewController new];
    preview.dataSource = self;
    [self presentViewController:preview animated:YES completion:nil];
}

- (NSInteger) numberOfPreviewItemsInPreviewController: 
(QLPreviewController *) controller {
    return [self.pdfs count];
}

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller 
                      previewItemAtIndex: (NSInteger) index {
    return (self.pdfs)[index];
}



@end
