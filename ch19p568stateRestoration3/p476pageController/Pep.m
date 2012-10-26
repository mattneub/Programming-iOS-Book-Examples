

#import "Pep.h"

@interface Pep ()
@property (nonatomic, weak) IBOutlet UILabel* name;
@property (nonatomic, weak) IBOutlet UIImageView* pic;
@end

@implementation Pep

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"pep encode");
    [coder encodeObject:self.boy forKey:@"boy"];
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"pep decode");
    NSString* boy = [coder decodeObjectForKey:@"boy"];
    if (boy) {
        self.boy = boy;
        [self updateInterface];
    }
    [super decodeRestorableStateWithCoder:coder];
}

- (id) initWithPepBoy: (NSString*) inputboy nib: (NSString*) nib bundle: (NSBundle*) bundle {
    self = [self initWithNibName:nib bundle:bundle];
    if (self) {
        self->_boy = [inputboy copy];
        self.restorationIdentifier = @"pep";
    }
    return self;
}

/*
 Here's the key fact: viewDidLoad is first, before decode.
 So, having loaded our view and updated our interface,
 we can update our interface *again* in decode, correcting it to look right.
 When the "curtain is torn away", we will be displaying the right Pep Boy.
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"pep viewdidload");
    [self updateInterface];
}

- (void) updateInterface {
    self.name.text = self.boy;
    self.pic.image = [UIImage imageNamed:
                      [NSString stringWithFormat: @"%@.jpg", [self.boy lowercaseString]]];
}


@end
