

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController

/*
 Just a sandbox to try out user-editable styles.
 User can govern bold, italic, underline but not color.
 Notice that you don't get any delegate message when the user changes styling!
 */

-(void)viewDidLoad {
    [super viewDidLoad];
    NSMutableAttributedString* mas = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    [mas addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 5)];
    [mas addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(6, 5)];
    self.textField.attributedText = mas;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%@", @"here"); // not called when user changes styling
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
