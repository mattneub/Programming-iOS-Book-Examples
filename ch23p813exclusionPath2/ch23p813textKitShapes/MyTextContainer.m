

#import "MyTextContainer.h"

@implementation MyTextContainer

-(CGRect)lineFragmentRectForProposedRect:(CGRect)proposedRect atIndex:(NSUInteger)characterIndex writingDirection:(NSWritingDirection)baseWritingDirection remainingRect:(CGRect *)remainingRect {
    
    CGRect result = [super lineFragmentRectForProposedRect:proposedRect atIndex:characterIndex writingDirection:baseWritingDirection remainingRect:remainingRect];
    
    CGRect r = CGRectMake(0,0,self.size.width,self.size.height);
    UIBezierPath* circle = [UIBezierPath bezierPathWithOvalInRect:r];
    
    CGPoint p = result.origin;
    while (![circle containsPoint:p]) {
        p.x += .1;
        result.origin = p;
    }
    CGFloat w = result.size.width;
    p = result.origin;
    p.x += w;
    while (![circle containsPoint:p]) {
        w -= .1;
        result.size.width = w;
        p = result.origin;
        p.x += w;
    }
    
    return result;
    
}

@end
