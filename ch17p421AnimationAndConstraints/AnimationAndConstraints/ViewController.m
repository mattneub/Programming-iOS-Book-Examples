

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *v;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#define which 1 // and 2

- (IBAction)doButton:(id)sender {
    switch (which) {
        case 1: {
            CGPoint p = _v.center;
            p.x += 100;
            [UIView animateWithDuration:1 animations:^{
                _v.center = p;
            } completion:^(BOOL b){
                // if we do not do something like this...
                // then when we rotate, layout happens, and we will revert to our original position
                NSArray* cons = self.view.constraints;
                NSIndexSet* ixx =
                [cons indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    NSLayoutConstraint* con = obj;
                    return (con.firstItem == _v) && (con.firstAttribute == NSLayoutAttributeLeading);
                }];
                NSLayoutConstraint* con = [cons objectsAtIndexes:ixx][0];
                con.constant = _v.frame.origin.x; // and this will cause view / viewcontroller layout
            }];
            break;
        }
        case 2: {
            // however, there's a better way: just set the constraint *as* the animation!
            // the constraint is not an animatable property, so just set it
            NSArray* cons = self.view.constraints;
            NSIndexSet* ixx =
            [cons indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                NSLayoutConstraint* con = obj;
                return (con.firstItem == _v) && (con.firstAttribute == NSLayoutAttributeLeading);
            }];
            NSLayoutConstraint* con = [cons objectsAtIndexes:ixx][0];
            con.constant += 100;
            // so what do we actually animate? here's the trick: animate the act of layout
            [UIView animateWithDuration:1 animations:^{
                [_v layoutIfNeeded]; // or could say [self.view layoutIfNeeded]
                // note that without that line, the position just jumps
                // (comment it out and see)
            }];
            break;
        }
    }
}

/*
 Log messages show that at startup and on rotation we get:
  vc: update
  v: update
  vc: will layout
  v: layout
  vc: did layout
  v: draw
 
 Moreover, we are guaranteed that "update" percolates up
 while layout and draw percolate up
 
 So at launch we get (v1 is the inner view):
 
 v (1): update
 vc: update
 v (0): update
 vc: will layout
 v (0): layout
 vc: did layout
 v (1): layout
 v (0): draw
 v (1): draw
 
 But when we rotate, we get:
 
  vc: update
  v (0): update
  vc: will layout
  v (0): layout
  vc: did layout
  v (0): draw

 So the view controller goes thru the whole cycle with its view, but nothing is happening in the subview
 that requires any updating
 
 */

- (void) viewWillLayoutSubviews {
    NSLog(@"vc: will layout");
}

- (void) viewDidLayoutSubviews {
    NSLog(@"vc: did layout");
}

-(void)updateViewConstraints {
    NSLog(@"vc: update");
    [super updateViewConstraints];
}


@end
