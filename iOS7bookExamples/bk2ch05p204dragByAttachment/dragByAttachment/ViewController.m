//
//  ViewController.m
//  dragByAttachment
//
//  Created by Matt Neuburg on 8/11/13.
//  Copyright (c) 2013 Matt Neuburg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIDynamicAnimatorDelegate>
@property (strong, nonatomic) UIDynamicAnimator* anim;
@property (strong, nonatomic) UIAttachmentBehavior* att;
@property (strong, nonatomic) NSMutableArray* atts;
@end

@implementation ViewController

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    NSLog(@"%@", @"pause"); // pauses if the drag pauses
}
-(void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    NSLog(@"%@", @"resume");
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*

- (IBAction)panning:(UIPanGestureRecognizer*)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        self.anim = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        self.anim.delegate = self;
        
        self.atts = [NSMutableArray new];
        CGRect r = CGRectInset(g.view.frame, -20, -20);
        CGRect f = g.view.frame;
        CGPoint cen = g.view.center;
        CGFloat damp = 0.95;
        CGFloat freq = 200;

        CGPoint p;
        UIOffset off;
        UIAttachmentBehavior* att;
        
        p = CGPointMake(CGRectGetMinX(r), CGRectGetMinY(r));
        off = UIOffsetMake(CGRectGetMinX(f)-cen.x, CGRectGetMinY(f)-cen.y);
        att = [[UIAttachmentBehavior alloc] initWithItem:g.view offsetFromCenter:off attachedToAnchor:p];
        att.damping = damp; att.frequency = freq;
        [self.anim addBehavior:att];
        [self.atts addObject: att];
        
        p = CGPointMake(CGRectGetMaxX(r), CGRectGetMaxY(r));
        off = UIOffsetMake(CGRectGetMaxX(f)-cen.x, CGRectGetMaxY(f)-cen.y);
        att = [[UIAttachmentBehavior alloc] initWithItem:g.view offsetFromCenter:off attachedToAnchor:p];
        att.damping = damp; att.frequency = freq;
        [self.anim addBehavior:att];
        [self.atts addObject: att];
        
        p = CGPointMake(CGRectGetMaxX(r), CGRectGetMinY(r));
        off = UIOffsetMake(CGRectGetMaxX(f)-cen.x, CGRectGetMinY(f)-cen.y);
        att = [[UIAttachmentBehavior alloc] initWithItem:g.view offsetFromCenter:off attachedToAnchor:p];
        att.damping = damp; att.frequency = freq;
        [self.anim addBehavior:att];
        [self.atts addObject: att];
        
        p = CGPointMake(CGRectGetMinX(r), CGRectGetMaxY(r));
        off = UIOffsetMake(CGRectGetMinX(f)-cen.x, CGRectGetMaxY(f)-cen.y);
        att = [[UIAttachmentBehavior alloc] initWithItem:g.view offsetFromCenter:off attachedToAnchor:p];
        att.damping = damp; att.frequency = freq;
        [self.anim addBehavior:att];
        [self.atts addObject: att];



    }
    else if (g.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [g translationInView: g.view.superview];
        for (UIAttachmentBehavior* att in self.atts) {
            CGPoint p = att.anchorPoint;
            p.x += delta.x; p.y += delta.y;
            att.anchorPoint = p;
        }
        [g setTranslation: CGPointZero inView: g.view.superview];
    }
    
    else {
        NSLog(@"%f %f %f", self.att.length, self.att.damping, self.att.frequency);
        self.atts = nil;
        self.anim = nil;
        g.view.transform = CGAffineTransformIdentity;
    }
}

*/

- (IBAction)panning:(UIPanGestureRecognizer*)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        self.anim = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        self.anim.delegate = self;
        CGPoint loc = [g locationOfTouch:0 inView:g.view];
        CGPoint cen = CGPointMake(CGRectGetMidX(g.view.bounds), CGRectGetMidY(g.view.bounds));
        UIOffset off = UIOffsetMake(loc.x-cen.x, loc.y-cen.y);
        CGPoint anchor = [g locationOfTouch:0 inView:self.view];
        UIAttachmentBehavior* att = [[UIAttachmentBehavior alloc] initWithItem:g.view offsetFromCenter:off attachedToAnchor:anchor];
        [self.anim addBehavior:att];
        self.att = att;
    }
    else if (g.state == UIGestureRecognizerStateChanged) {
        self.att.anchorPoint = [g locationOfTouch:0 inView:self.view];
    }
    else {
        self.anim = nil;
    }
}



@end
