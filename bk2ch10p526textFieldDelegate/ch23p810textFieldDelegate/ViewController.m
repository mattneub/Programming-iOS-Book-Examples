

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tf;

@end

@implementation ViewController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

-(void)viewDidLoad {
    [super viewDidLoad];
    self.tf.allowsEditingTextAttributes = YES;

    UIMenuItem *mi = [[UIMenuItem alloc] initWithTitle:@"Expand"
                                                action:@selector(expand:)];
    UIMenuController *mc = [UIMenuController sharedMenuController];
    mc.menuItems = @[mi];
}

#pragma clang diagnostic pop


/*
- (void) dummy: (id) dummy {
    NSLog(@"%@", @"dummy");
}
 */

-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSLog(@"here '%@'", string);
    
    if ([string isEqualToString:@"\n"])
        return YES; // otherwise, our automatic keyboard dismissal trick won't work
    
    NSString* lc = [string lowercaseString];
    textField.text =
    [textField.text stringByReplacingCharactersInRange:range
                                            withString:lc];
    
    NSDictionary* d = textField.typingAttributes;
    NSMutableDictionary* md = [d mutableCopy];
    [md addEntriesFromDictionary:
     @{NSForegroundColorAttributeName:[UIColor redColor], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    textField.typingAttributes = md;
    
    return NO;
}


@end
