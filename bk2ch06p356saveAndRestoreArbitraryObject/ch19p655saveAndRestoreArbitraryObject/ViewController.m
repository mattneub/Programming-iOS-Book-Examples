

#import "ViewController.h"
#import "Thing.h"

@interface ViewController () <UIAlertViewDelegate, UIObjectRestoration>
@property (nonatomic, strong) Thing* thing;
@end

@implementation ViewController

+(Thing*)makeThing {
    Thing* thing = [Thing new];
    [UIApplication registerObjectForStateRestoration:thing restorationIdentifier:@"thing"];
    // thing.objectRestorationClass = self;
    return thing;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.thing = [[self class] makeThing];
}

+(id<UIStateRestoring>)objectWithRestorationIdentifierPath:(NSArray *)ip coder:(NSCoder *)coder {
    NSLog(@"%@", ip);
    return [self makeThing];
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeObject:self.thing forKey:@"mything"]; // must show this object to the archiver
}

-(void)applicationFinishedRestoringState {
    NSLog(@"%@", @"finished view controller");
    // self.thing.restorationParent = self;
}

- (IBAction)doRead:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Read" message:self.thing.word delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


- (IBAction)doWrite:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Write" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.thing.word = [alertView textFieldAtIndex:0].text;
    }
}

@end
