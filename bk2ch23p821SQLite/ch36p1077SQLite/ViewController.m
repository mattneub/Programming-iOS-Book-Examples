

#import "ViewController.h"
#import "FMDatabase.h"

@interface ViewController ()

@end

@implementation ViewController

// tap each button in turn, watch console

- (IBAction)doButton:(id)sender {
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:@"people.db"];
    
    [fm removeItemAtPath:dbpath error:nil]; // in case we already did this once
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Ooops");
        return;
    }
    [db executeUpdate:@"create table people (lastname text, firstname text)"];
    
    [db beginTransaction];
    // note: right way to supply literals
    [db executeUpdate:@"insert into people (firstname, lastname) values (?,?)",
     @"Matt", @"Neuburg"];
    [db executeUpdate:@"insert into people (firstname, lastname) values (?,?)",
     @"Snidely", @"Whiplash"];
    [db executeUpdate:@"insert into people (firstname, lastname) values (?,?)",
     @"Dudley", @"Doright"];
    [db commit];
    
    NSLog(@"I think I created it");
    [db close];
}

- (IBAction)doButton2:(id)sender {
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:@"people.db"];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Ooops");
        return;
    }
    
    FMResultSet *rs = [db executeQuery:@"select * from people"];
    while ([rs next]) {
        // note: new keyed subscripting available
        NSLog(@"%@ %@", rs[@"firstname"], rs[@"lastname"]);
    }
    
    [db close];
}


@end
