

#import <Foundation/Foundation.h>


@interface MyClass : NSObject 
@property (nonatomic, strong) NSMutableArray* theData;
// previously was "assign" but under ARC there's no reason for this
// may as well just make strong, synthesize, and let everything just work
// WARNING: note, however, that synthesized ivars don't show up in the debugger

@end
