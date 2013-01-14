

#import "Pep.h"

@interface Pep ()
@property (nonatomic, weak) IBOutlet UILabel* name;
@property (nonatomic, weak) IBOutlet UIImageView* pic;
@end

@implementation Pep

// given a Pep boy's name, we display his name and picture

// we are the restoration class
// we are being asked to vend a new basic Pep
// we have encoded which Pep boy was being displayed, so we can call init with that info

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)ic
                                                            coder:(NSCoder *)coder {
    NSLog(@"pep %@", ic);
    UIViewController* result = nil;
    NSString* id = [ic lastObject];
    if ([id isEqualToString:@"pep"]) {
        NSString* boy = [coder decodeObjectForKey:@"boy"];
        result = [[Pep alloc] initWithPepBoy:boy nib:nil bundle:nil];
    }
    return result;
}


-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"pep encode");
    [coder encodeObject:self.boy forKey:@"boy"]; // this is our only state-saving move!
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"pep decode");
    // nothing further to do
    [super decodeRestorableStateWithCoder:coder];
}

- (id) initWithPepBoy: (NSString*) inputboy nib: (NSString*) nib bundle: (NSBundle*) bundle {
    self = [self initWithNibName:nib bundle:bundle];
    if (self) {
        self->_boy = [inputboy copy];
        self.restorationIdentifier = @"pep"; //
        self.restorationClass = [self class]; //
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.name.text = self.boy;
    self.pic.image = [UIImage imageNamed:
                      [NSString stringWithFormat: @"%@.jpg", [self.boy lowercaseString]]];
}

- (IBAction)doButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
