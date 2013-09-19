

#import "RootViewController.h"
#import "Pep.h"

@interface RootViewController ()
@property (nonatomic, strong) NSArray* pep;
@end

@implementation RootViewController

// warning: do NOT do this! it was a huge mistake and took me a long time to fix
// the reason is: we do not want our returned root view controller to be a new different one;
// we want it to be the existing one that's already in the interface

/*
+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)ic
                                                            coder:(NSCoder *)coder {
    NSLog(@"rvc %@", ic);
    UIViewController* result = nil;
    NSString* id = [ic lastObject];
    if ([id isEqualToString:@"root"]) {
        result = [RootViewController new];
    }
    return result;
}
 */

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"rvc encode");
    // nothing to do
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"rvc decode");
    // nothing to do
    [super decodeRestorableStateWithCoder:coder];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->_pep = @[@"Manny", @"Moe", @"Jack"];
        self.restorationIdentifier = @"root";
        // no restoration class
        // let the runtime or app delegate handle it
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"root view will appear");
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"root view did appear");
    [super viewDidAppear:animated];
}


- (IBAction)doButton:(id)sender {
    NSInteger tag = [(UIButton*)sender tag];
    NSString* whichPep = self.pep[tag-1];
    Pep* onePep = [[Pep alloc] initWithPepBoy:whichPep nib:nil bundle:nil];
    [self presentViewController:onePep animated:YES completion:nil];
}


@end
