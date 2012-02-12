

#import <Foundation/Foundation.h>


@interface Person : NSObject <NSCoding> 

@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* lastName;

@end
