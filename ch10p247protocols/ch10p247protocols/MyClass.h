

#import <Foundation/Foundation.h>

/*
 
 Won't compile because we don't inherit copyWithZone:
 
 Comment out second @interface and uncomment first one;
 then we'll compile, but we get a warning because we don't
 *implement* copyWithZone:
 
 */

// @interface MyClass : NSObject <NSCopying>

@interface MyClass : NSObject

@end
