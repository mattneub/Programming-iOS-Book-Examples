

#import "ViewController.h"
#import "SecondViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation ViewController {
    __weak IBOutlet UIImageView *iv;
    UIImagePickerController* p;
}

- (IBAction)doTake:(id)sender {
    BOOL ok = [UIImagePickerController isSourceTypeAvailable:
               UIImagePickerControllerSourceTypeCamera];
    if (!ok) {
        NSLog(@"no camera");
        return;
    }
    NSArray* arr = [UIImagePickerController availableMediaTypesForSourceType:
                    UIImagePickerControllerSourceTypeCamera];
    if ([arr indexOfObject:(NSString*)kUTTypeImage] == NSNotFound) {
        NSLog(@"no stills");
        return;
    }
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
    picker.delegate = self;
    
    picker.showsCameraControls = NO;
        
    CGRect f = self.view.window.bounds;
    UIView* v = [[UIView alloc] initWithFrame:f];
    UITapGestureRecognizer* t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    t.numberOfTapsRequired = 2;
    [v addGestureRecognizer:t];
    picker.cameraOverlayView = v;
    
    [self presentViewController:picker animated:YES completion:nil];
    self->p = picker;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* im = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!im)
        return;
    SecondViewController* svc = [[SecondViewController alloc] initWithNibName:nil bundle:nil image:im];
    [picker pushViewController:svc animated:YES];
}

- (void) tap: (id) g {
    [self->p takePicture];
}

- (void)navigationController:(UINavigationController *)nc 
       didShowViewController:(UIViewController *)vc 
                    animated:(BOOL)animated {
    if ([vc isKindOfClass:[SecondViewController class]]) {
        [nc setToolbarHidden: YES];
        return;
    }
    [nc setToolbarHidden:NO];
    CGRect f = nc.toolbar.frame;
    CGFloat h = 56;
    CGFloat diff = h - f.size.height;
    f.size.height = h;
    f.origin.y -= diff;
    nc.toolbar.frame = f;
    
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
                                                          style:UIBarButtonItemStyleBordered 
                                                         target:self 
                                                         action:@selector(doCancel:)];
    [nc.topViewController setToolbarItems:[NSArray arrayWithObject:b]];
    nc.topViewController.title = @"Retake";
}

- (void) doCancel: (id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) doUse: (UIImage*) im {
    if (im)
        self->iv.image = im;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
