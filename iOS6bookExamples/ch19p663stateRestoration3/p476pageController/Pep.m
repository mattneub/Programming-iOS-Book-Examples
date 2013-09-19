

#import "Pep.h"

@interface Pep ()
@property (nonatomic, weak) IBOutlet UILabel* name;
@property (nonatomic, weak) IBOutlet UIImageView* pic;
@end

@implementation Pep

/*
 Self-restoring Pep object.
 Here's the key fact: viewDidLoad is first, before decode.
 So, having loaded our view and updated our interface initially,
 we can update our interface *again* in decode, correcting it to look right.
 When the "curtain is torn away", we will be displaying the right Pep Boy.
 */

/* order of events:
 rvc init
 rvc viewdidload
 pep init
 pep viewdidload
 rvc decode
 pep decode
*/

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
    NSLog(@"pep init");
    self = [self initWithNibName:nib bundle:bundle];
    if (self) {
        self->_boy = [inputboy copy];
        self.restorationIdentifier = @"pep";
        // no need for a restoration class, because the system is doing nothing for us in this regard
        // creating an actual Pep object is entirely up to us, and we already know how to do that
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"pep viewdidload");
    [self updateInterface];
}

// move interface config into a shared method

- (void) updateInterface {
    self.name.text = self.boy;
    self.pic.image = [UIImage imageNamed:
                      [NSString stringWithFormat: @"%@.jpg", [self.boy lowercaseString]]];
}


@end
