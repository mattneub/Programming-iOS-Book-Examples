

#import <UIKit/UIKit.h>

@class CATextLayer;

@interface StyledText : UIView {
    
}
@property (nonatomic, copy) NSAttributedString* text;
@property (nonatomic, assign) CATextLayer* textLayer;

@end
