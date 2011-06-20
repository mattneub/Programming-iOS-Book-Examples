

#import <UIKit/UIKit.h>

@class CATextLayer;

@interface StyledText : UIView {
    
}
@property (nonatomic, copy) NSAttributedString* text;
@property (nonatomic, retain) NSMutableArray* theLines;
@property (nonatomic, retain) NSMutableArray* theBounds;

@end
