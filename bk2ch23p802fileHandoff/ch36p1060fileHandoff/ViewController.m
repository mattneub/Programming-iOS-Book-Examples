

#import "ViewController.h"
@import QuickLook;

@interface ViewController () <UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource>
@property (nonatomic, weak) IBOutlet UIWebView *wv;
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

- (void) displayPDF: (NSURL*) url {
    self.pdf = url;
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    [self.wv loadRequest:req];
}

- (NSURL*) locatePDF {
    NSURL* url = nil;
    NSFileManager* fm = [NSFileManager new];
    NSError* err = nil;
    NSURL* docsurl =
    [fm URLForDirectory:NSDocumentDirectory
               inDomain:NSUserDomainMask appropriateForURL:nil
                 create:YES error:&err];
    NSDirectoryEnumerator* dir =
    [fm enumeratorAtURL:docsurl includingPropertiesForKeys:nil options:0 errorHandler:nil];
    for (NSURL* f in dir)
        if ([[f pathExtension] isEqualToString: @"pdf"]) {
            url = f;
            break;
        }
    return url;
}

- (IBAction) doHandOffPDF: (id) sender {
    NSURL * url = self.pdf;
    if (!url) // see if we have one
        url = [self locatePDF];
    if (!url) {
        NSLog(@"%@", @"No pdf to hand off");
        return;
    }
    self.dic =
        [UIDocumentInteractionController interactionControllerWithURL:url];
    BOOL ok =
        [self.dic presentOpenInMenuFromRect:[sender bounds]
                                 inView:sender animated:YES];
    if (!ok)
        NSLog(@"%@", @"That didn't work out");
}

- (IBAction) doPreview: (id) sender {
    NSURL * url = self.pdf;
    if (!url) // see if we have one
        url = [self locatePDF];
    if (!url) {
        NSLog(@"%@", @"No pdf to preview");
        return;
    }
    self.dic =
    [UIDocumentInteractionController interactionControllerWithURL:url];
    self.dic.delegate = self;
    [self.dic presentPreviewAnimated:YES];
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview:
(UIDocumentInteractionController *) controller {
    return self;
}

- (IBAction)doPreviewMultipleUsingQuickLook:(id)sender {
    // obtain URLs of PDFs as an array
    NSFileManager* fm = [NSFileManager new];
    NSURL* docsurl = [fm URLForDirectory:NSDocumentDirectory
                                inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSDirectoryEnumerator* dir = [fm enumeratorAtURL:docsurl includingPropertiesForKeys:nil options:0 errorHandler:nil];
    if (!dir)
        return; // proper error-checking omitted
    NSMutableArray* marr = [NSMutableArray new];
    for (NSURL* f in dir) {
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
    return self.pdfs[index];
}



@end
