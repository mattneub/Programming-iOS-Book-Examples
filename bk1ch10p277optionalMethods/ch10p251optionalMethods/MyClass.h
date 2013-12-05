

#import <Foundation/Foundation.h>

@protocol MyProtocol
@optional
-(void) woohoo;
@end

@interface MyClass : NSObject <MyProtocol>

@end
