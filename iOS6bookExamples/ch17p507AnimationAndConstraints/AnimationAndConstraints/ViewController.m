

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *v;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#define which 1 // and 2 and 3 and 4

- (IBAction)doButton:(id)sender {
    UIView* sup = _v.superview;
    switch (which) {
        case 1: {
            CGPoint p = _v.center;
            p.x += 100;
            [UIView animateWithDuration:1 animations:^{
                _v.center = p;
            }]; // everything *looks* okay, but it isn't
            break;
        }
        case 2: {
            CGPoint p = _v.center;
            p.x += 100;
            [UIView animateWithDuration:1 animations:^{
                _v.center = p;
            } completion:^(BOOL b){
                [_v layoutIfNeeded]; // this is what will happen at layout time
            }];
            break;
        }
        case 3: {
            CGPoint p = _v.center;
            p.x += 100;
            [UIView animateWithDuration:1 animations:^{
                _v.center = p;
                // solution 1: fix constraints to match
                NSArray* cons = sup.constraints;
                NSUInteger ix =
                [cons indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    NSLayoutConstraint* con = obj;
                    return ((con.firstItem == _v) && (con.firstAttribute == NSLayoutAttributeLeading));
                }];
                NSLayoutConstraint* con = cons[ix];
                /*
                 [sup removeConstraint:con];
                 [sup addConstraint:
                 [NSLayoutConstraint
                 constraintWithItem:con.firstItem attribute:con.firstAttribute
                 relatedBy:con.relation
                 toItem:con.secondItem attribute:con.secondAttribute
                 multiplier:1 constant:_v.frame.origin.x]];
                 */
                con.constant = _v.frame.origin.x; // and this will cause view / viewcontroller layout

            }];
            break;
        }

        case 4: {
            // solution 2: just set the constraint *as* the animation!
            NSArray* cons = sup.constraints;
            NSUInteger ix =
            [cons indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                NSLayoutConstraint* con = obj;
                return ((con.firstItem == _v) && (con.firstAttribute == NSLayoutAttributeLeading));
            }];
            NSLayoutConstraint* con = cons[ix];
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
