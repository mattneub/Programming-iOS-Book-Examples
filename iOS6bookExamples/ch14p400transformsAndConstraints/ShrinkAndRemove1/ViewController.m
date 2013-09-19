

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *otherView;

@end

# define which 1 // and 2

@implementation ViewController

- (IBAction)doButton:(id)sender {
    [self shrinkAndRemove:sender];
}

-(void)shrinkAndRemove:(id)what {
    UIView* v = (UIView*) self.otherView;
    
    switch (which) {
        case 2: {
            // the solution is to remove all constraints affecting our view, first
            NSMutableArray* cons = [NSMutableArray array];
            for (NSLayoutConstraint* con in self.view.constraints)
                if (con.firstItem == self.otherView || con.secondItem == self.otherView)
                    [cons addObject:con];
            
            [self.view removeConstraints:cons];
            [self.otherView removeConstraints:self.otherView.constraints];
            // but that alone still doesn't solve the problem
            // there is no conflict, but the view still just vanishes
            // why? because now it has no meaningful position dictated by constraints
            // the solution:
            self.otherView.translatesAutoresizingMaskIntoConstraints = YES;


            // fall thru to next case
        }
        case 1: {
            // this code worked fine if the nib wasn't using autolayout
            // but if the nib *is* using autolayout, kaboom, we get a constraint conflict
            // and there is no animation (the view just vanishes)
            [UIView beginAnimations:@"removeThisView" context:(__bridge void*)v];
            [UIView setAnimationDidStopSelector:@selector(stopped:fin:context:)];
            [UIView setAnimationDelegate:self];
            v.transform = CGAffineTransformMakeScale(0,0);
            [UIView commitAnimations];
        }
    }
}



-(void)stopped:(NSString*)identifier fin:(BOOL)fin context:(void*) context {
    if ([identifier isEqualToString:@"removeThisView"]) {
        UIView* v = (__bridge id)context;
        [v removeFromSuperview];
        // NSLog(@"%@", @"here");
    }
}



@end
