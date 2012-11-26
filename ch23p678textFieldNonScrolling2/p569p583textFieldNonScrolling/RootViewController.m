

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, weak) IBOutlet UIView *slidingView;
@property (nonatomic, weak) UIView* fr;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray* verticalConstraints;
@end

@implementation RootViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // new in iOS 5
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardMove:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];

}

- (void)textFieldDidBeginEditing:(UITextField *)tf {
    self.fr = tf; // keep track of first responder
    // oooh oooh let's illustrate another new iOS 6 feature
    tf.clearsOnInsertion = YES;
    // user *can* still tap to set insertion point and insert there
    // but *default* is there is no insertion point, and typing clears contents
}

/* watching the iOS 5 iPad notifications, we see that we get show when the keyboard moves into docked
 position, either from offscreen or because the user docks it, and we get hide if the keyboard
 moves from docked position, either offscreen or elsewhere onscreen
 
 otherwise we get didChangeFrame consistently each time the movable keyboard moves, because it comes onscreen or goes offscreen or is dragged by the user; we could use this to detect that the keyboard is in the way, but we don't really have to, because it's movable by the user
 
 the upshot is that your old code will continue to work - if you get show, and if 
 this caused you to move the scroll view, then you will get hide and you can move it back again,
 just as before
 
 note that we also get "moved" on iPhone, so you *could* move all your code over to that
 */

- (void) keyboardShow: (NSNotification*) n {
    NSLog(@"show");
    NSDictionary* d = [n userInfo];
    CGRect r = [d[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    r = [self.slidingView convertRect:r fromView:nil];
    CGRect f = self.fr.frame;
    CGFloat y = CGRectGetMaxY(f) + r.size.height - self.slidingView.bounds.size.height + 5;
    NSNumber* duration = d[UIKeyboardAnimationDurationUserInfoKey];
    if (r.origin.y < CGRectGetMaxY(f)) {
        [UIView animateWithDuration:[duration floatValue] animations:^{
            for (NSLayoutConstraint* con in self.verticalConstraints) {
                con.constant = -y;
            }
            [self.view layoutIfNeeded];
        }];
    }
}

- (BOOL)textFieldShouldReturn: (UITextField*) tf {
    [tf resignFirstResponder];
    return YES;
}

- (void) keyboardHide: (NSNotification*) n {
    NSLog(@"hide");
    NSNumber* duration = n.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] animations:^{
        for (NSLayoutConstraint* con in self.verticalConstraints) {
            con.constant = 0;
        }
        [self.view layoutIfNeeded];
    }];
}

- (void) keyboardMove: (NSNotification*) n {
    NSLog(@"move to %@", [n userInfo][UIKeyboardFrameEndUserInfoKey]);
    // we could use this to detect whether the keyboard is hiding us
    // but we don't have to, because if we didn't get "show" ...
    // ... the user can move the keyboard if it's in the way
}

@end
