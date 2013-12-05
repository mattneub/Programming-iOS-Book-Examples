

#import <Foundation/Foundation.h>

@interface Thing : NSObject  <UIStateRestoring>
@property (copy, nonatomic) NSString* word;
@property (strong, nonatomic) Class<UIObjectRestoration> objectRestorationClass;
@property (strong, nonatomic) id<UIStateRestoring> restorationParent;

@end
