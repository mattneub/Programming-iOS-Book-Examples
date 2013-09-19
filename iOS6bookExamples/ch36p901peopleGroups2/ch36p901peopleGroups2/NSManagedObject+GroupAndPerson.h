

#import <CoreData/CoreData.h>

@interface NSManagedObject (GroupAndPerson)

@property (nonatomic) NSString *firstName, *lastName;
@property (nonatomic) NSString *name, *uuid;
@property (nonatomic) NSDate* timestamp;
@property (nonatomic) NSManagedObject* group;

@end
