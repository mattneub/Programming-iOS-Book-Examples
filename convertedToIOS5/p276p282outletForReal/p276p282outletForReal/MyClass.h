

#import <Foundation/Foundation.h>


@interface MyClass : NSObject 
// this is what memory management for an outlet will typically *really* look like
// note that "strong" cannot be omitted here:
// "assign" is the default, but it's not the same as "weak" and is regarded as inappropriate
// retain is now so efficient that there is little reason to use weak rather than strong...
// ...even if we know the object will ultimately be retained by the interface
// moreover, a synthesized accessor absolutely must explicitly declare its policy under ARC
@property (nonatomic, strong) IBOutlet UILabel* theLabel;


@end
