

#import "Pep.h"

@implementation Pep
@synthesize name, pic, boy;

// given a Pep boy's name, we display his name and picture

- (id) initWithPepBoy: (NSString*) inputboy nib: (NSString*) nib bundle: (NSBundle*) bundle {
    self = [self initWithNibName:nib bundle:bundle];
    if (self) {
        self.boy = inputboy;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
