

#import "RootViewController.h"

@implementation RootViewController
@synthesize b;
@synthesize wv, pdf, pdfs, dic;

- (void)dealloc
{
    [wv stopLoading];
    [wv setDelegate: nil];
    [wv release];
    [pdf release];
    [pdfs release];
    [dic release];
    [b release];
    [super dealloc];
}

// run on device

// first, use some other application, such as DropBox or GoodReader...
// to hand off a pdf to this application

- (void) displayPDF: (NSURL*) url {
    self.pdf = url;
    self.dic = [UIDocumentInteractionController interactionControllerWithURL:url];
    UIImage* icon = [[self.dic icons] lastObject];
    [self.b setImage:icon forState:UIControlStateNormal];
    b.enabled = YES;
    
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    [self->wv loadRequest:req];
}

// then tap the Hand Off button to try previewing...
// and perhaps handing the currently showing PDF to another application

- (IBAction)doButton:(id)sender {
    if (!self.pdf)
        return;
    self.dic = [UIDocumentInteractionController interactionControllerWithURL:self.pdf];
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
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    docsdir = [docsdir stringByAppendingPathComponent:@"Inbox"];
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSDirectoryEnumerator* direnum = [fm enumeratorAtPath:docsdir];
    [fm changeCurrentDirectoryPath: docsdir];
    NSMutableArray* marr = [NSMutableArray array];
    for (NSString* file in direnum) {
        [direnum skipDescendants];
        if ([[file pathExtension] isEqualToString: @"pdf"]) {
            NSURL* url = [NSURL fileURLWithPathComponents:
                          [NSArray arrayWithObjects: docsdir, file, nil]];
            [marr addObject: url];
        }
    }
    self.pdfs = marr; // retain policy
    [fm release];
    if (![self.pdfs count])
        return;
    // show preview interface
    QLPreviewController* preview = [[QLPreviewController alloc] init];
    preview.dataSource = self;
    [self presentModalViewController:preview animated:YES];
    [preview release];
}

- (NSInteger) numberOfPreviewItemsInPreviewController: 
(QLPreviewController *) controller {
    return [self.pdfs count];
}

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller 
                      previewItemAtIndex: (NSInteger) index {
    return [self.pdfs objectAtIndex:index];
}



@end
