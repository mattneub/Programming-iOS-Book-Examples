
#import "MyCell.h"

@implementation MyCell

- (void) dealloc {
    // prove that cells are allowed to die
    NSLog(@"cell death %@", self.textLabel.text);
}

@end
