

#import <Foundation/Foundation.h>


@interface MyClass1 : NSObject {
    NSMutableArray* theData;
}
@property (nonatomic, retain, getter=theDataGetter) NSMutableArray* theData;

@end
