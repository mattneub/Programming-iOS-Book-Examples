

#import "ViewController.h"

@implementation ViewController {
    IBOutlet __weak UILabel *theLabel;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self->theLabel sizeToFit];
}


@end
