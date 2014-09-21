

#import "Helper.h"

@implementation Helper

- (void) tellViewController: (UIViewController*) vc newSize: (CGSize) sz {
    [vc viewWillTransitionToSize:sz withTransitionCoordinator:nil];
}

@end
