

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray* textFields;
@property (nonatomic, weak) UIResponder* fr;
@property (nonatomic, strong) UIView* accessoryView;
@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // configure accessory view
    NSArray* arr = [[UINib nibWithNibName:@"AccessoryView" bundle:nil] instantiateWithOwner:nil options:nil];
    self.accessoryView = arr[0];
    UIButton* b = self.accessoryView.subviews[0];
    [b addTarget:self action:@selector(doNextButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)textFieldDidBeginEditing:(UITextField *)tf {
    self.fr = tf; // keep track of first responder
    tf.inputAccessoryView = self.accessoryView;
    tf.keyboardAppearance = UIKeyboardAppearanceDark; // new in iOS 7
}

- (BOOL)textFieldShouldReturn: (UITextField*) tf {
    [tf resignFirstResponder];
    self.fr = nil;
    return YES;
}

- (void) doNextButton: (id) sender {
    NSUInteger ix = [self.textFields indexOfObject:self.fr];
    if (ix == NSNotFound)
        return; // shouldn't happen
    ix++;
    if (ix >= [self.textFields count])
        ix = 0;
    UIView* v = self.textFields[ix];
    [v becomeFirstResponder];
}


@end
