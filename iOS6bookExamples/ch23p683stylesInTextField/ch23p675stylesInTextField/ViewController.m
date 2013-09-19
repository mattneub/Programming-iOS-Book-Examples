

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController

/*
 
 Illustrates a simple use of attributed string in a UITextField. 
 The string is normally black, and becomes black when the user hits Return after editing text.
 But while editing, any new text appears in red.
 
 */

/*
 
 The example also churned up what may be a bug: if you uncomment the commented line,
 everything breaks - no underline, and no red either!
 
 */

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSDictionary* d = textField.typingAttributes;
    NSLog(@"%@", d);
    NSMutableDictionary* md = [NSMutableDictionary dictionaryWithDictionary:d];
    // md[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
    md[NSForegroundColorAttributeName] = [UIColor redColor];
    textField.typingAttributes = md;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSMutableAttributedString* mas = [textField.attributedText mutableCopy];
    [mas addAttribute:NSForegroundColorAttributeName
                value:[UIColor blackColor]
                range:NSMakeRange(0,mas.string.length)];
    textField.attributedText = mas;
    return YES;
}


@end
