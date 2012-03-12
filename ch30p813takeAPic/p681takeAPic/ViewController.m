

#import "ViewController.h"
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
//    picker.showsCameraControls = NO;
//    CGRect f = self.view.window.bounds;
//    CGFloat h = 53;
//    UIView* v = [[UIView alloc] initWithFrame:f];
//    UIView* v2 = [[UIView alloc] initWithFrame:CGRectMake(0,f.size.height-h,f.size.width,h)];
//    v2.backgroundColor = [UIColor redColor];
//    [v addSubview: v2];
//    UITapGestureRecognizer* t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//    t.numberOfTapsRequired = 2;
//    [v addGestureRecognizer:t];
//    picker.cameraOverlayView = v;
    [self presentViewController:picker animated:YES completion:nil];
    self->p = picker;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* im = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (im)
        self->iv.image = im;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) tap: (id) g {
    [self->p takePicture];
}


@end
