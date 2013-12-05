

#import "Thing.h"

@interface Thing ()
@end

@implementation Thing

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"thing encode");
    [coder encodeObject:self.word forKey:@"word"];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"thing decode");
    self.word = [coder decodeObjectForKey:@"word"];
}

-(void)applicationFinishedRestoringState {
    NSLog(@"%@", @"finished thing");
}

@end
