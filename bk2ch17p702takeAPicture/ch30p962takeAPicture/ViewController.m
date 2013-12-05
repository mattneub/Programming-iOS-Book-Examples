

#import "ViewController.h"
@import MobileCoreServices;

@interface ViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *iv;
@property (nonatomic, strong) UIImagePickerController* picker;

@end

@implementation ViewController

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
    picker.mediaTypes = @[(NSString*)kUTTypeImage];
    picker.allowsEditing = YES;
    picker.delegate = self;
    /*
     picker.showsCameraControls = NO;
     CGRect f = self.view.window.bounds;
     CGFloat h = 53;
     UIView* v = [[UIView alloc] initWithFrame:f];
     UIView* v2 = [[UIView alloc] initWithFrame:CGRectMake(0,f.size.height-h,f.size.width,h)];
     v2.backgroundColor = [UIColor redColor];
     [v addSubview: v2];
     UILabel* lab = [UILabel new];
     lab.text = @"Double tap to take a picture";
     lab.backgroundColor = [UIColor clearColor];
     [lab sizeToFit];
     lab.center = CGPointMake(CGRectGetMidX(v2.bounds), CGRectGetMidY(v2.bounds));
     [v2 addSubview:lab];
     UITapGestureRecognizer* t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
     t.numberOfTapsRequired = 2;
     [v addGestureRecognizer:t];
     picker.cameraOverlayView = v;
     */
    [self presentViewController:picker animated:YES completion:nil];
    self.picker = picker;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* im = info[UIImagePickerControllerOriginalImage];
    UIImage* edim = info[UIImagePickerControllerEditedImage];
    if (edim)
        im = edim;
    if (im)
        self.iv.image = im;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) tap: (id) g {
    [self.picker takePicture];
}


@end
