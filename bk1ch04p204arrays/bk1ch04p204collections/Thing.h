

#import <Foundation/Foundation.h>

@interface Thing : NSObject

- (__nonnull NSArray*) badMethod;
- (__nonnull NSArray<NSString*>*) goodMethod;

@end
