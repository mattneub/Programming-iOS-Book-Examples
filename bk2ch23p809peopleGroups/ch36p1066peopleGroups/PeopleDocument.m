
#import "PeopleDocument.h"

@implementation PeopleDocument

-(id)initWithFileURL:(NSURL *)url {
    self = [super initWithFileURL:url];
    if (self) {
        self->_people = [NSMutableArray array];
    }
    return self;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError {
    NSLog(@"loading %@", typeName);
    NSArray* arr = [NSKeyedUnarchiver unarchiveObjectWithData:contents];
    self.people = [NSMutableArray arrayWithArray:arr];
    return YES;
}

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError {
    NSLog(@"archiving %@", typeName);
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.people];
    return data;
}

@end
