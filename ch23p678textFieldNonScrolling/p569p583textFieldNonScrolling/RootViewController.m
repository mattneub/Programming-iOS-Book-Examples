

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) UIView* fr;
@end

@implementation RootViewController {
    CGPoint oldOffset;
}
@synthesize scrollView, fr;


- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize sz = self.scrollView.bounds.size;
    sz.height *= 2;
    self.scrollView.contentSize = sz;
    self.scrollView.scrollEnabled = NO;
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
    self->oldOffset = self.scrollView.contentOffset;
    NSDictionary* d = [n userInfo];
    CGRect r = [[d objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    r = [self.scrollView convertRect:r fromView:nil];
    CGRect f = self.fr.frame;
    CGFloat y = 
    CGRectGetMaxY(f) + r.size.height - self.scrollView.bounds.size.height + 5;
    if (r.origin.y < CGRectGetMaxY(f))
        [self.scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}

- (BOOL)textFieldShouldReturn: (UITextField*) tf {
    [tf resignFirstResponder];
    return YES;
}

- (void) keyboardHide: (NSNotification*) n {
    NSLog(@"hide");
    [self.scrollView setContentOffset:self->oldOffset animated:YES];
}

- (void) keyboardMove: (NSNotification*) n {
    NSLog(@"move to %@", [[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]);
    // we could use this to detect whether the keyboard is hiding us
    // but we don't have to, because if we didn't get "show" ...
    // ... the user can move the keyboard if it's in the way
}

@end
