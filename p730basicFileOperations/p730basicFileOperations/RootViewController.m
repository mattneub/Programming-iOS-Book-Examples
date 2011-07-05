

#import "RootViewController.h"
#import "Person.h"

@implementation RootViewController

- (void)dealloc
{
    [super dealloc];
}

- (IBAction)doButton1:(id)sender {
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", docs);
}

- (IBAction)doButton2:(id)sender {
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSError* err = nil;
    NSURL* docsurl = [fm URLForDirectory:NSDocumentDirectory 
                                inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
    [fm release];
    if (docsurl)
        NSLog(@"%@", docsurl);
    else
        NSLog(@"%@", err);
}

- (IBAction)doButton3:(id)sender {
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSError* err = nil;
    NSURL* suppurl = [fm URLForDirectory:NSApplicationSupportDirectory 
                                inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
    [fm release];
    if (suppurl)
        NSLog(@"%@", suppurl);
    else
        NSLog(@"%@", err);
}

- (IBAction)doButton4:(id)sender {
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* myfolder = [docs stringByAppendingPathComponent:@"MyFolder"];
    NSFileManager* fm = [[NSFileManager alloc] init];
    BOOL exists = [fm fileExistsAtPath:myfolder];
    if (!exists) {
        NSError* err = nil;
        BOOL ok = [fm createDirectoryAtPath:myfolder withIntermediateDirectories:NO 
                       attributes:nil error:&err];
        if (!ok) {
            NSLog(@"%@", err);
            [fm release];
            return;
        }
    }
    [fm release];
    // if we get here, myfolder exists
    // let's put a couple of files into it
    NSError* err = nil;
    BOOL ok = [@"howdy" writeToFile:[myfolder stringByAppendingPathComponent:@"file1.txt"] atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!ok) {
        NSLog(@"%@", err);
        return;
    }
    err = nil;
    ok = [@"hello" writeToFile:[myfolder stringByAppendingPathComponent:@"file2.txt"] atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!ok) {
        NSLog(@"%@", err);
        return;
    }
}

- (IBAction)doButton5:(id)sender {
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSError* err = nil;
    NSArray* arr = [fm contentsOfDirectoryAtPath:docs error:&err];
    [fm release];
    if (!arr) {
        NSLog(@"%@", err);
        return;
    }
    NSLog(@"%@", arr);
}

- (IBAction)doButton6:(id)sender {
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSError* err = nil;
    NSArray* arr = [fm subpathsOfDirectoryAtPath:docs error:&err];
    [fm release];
    if (!arr) {
        NSLog(@"%@", err);
        return;
    }
    NSLog(@"%@", arr);
}

- (IBAction)doButton7:(id)sender {
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSDirectoryEnumerator* dir = [fm enumeratorAtPath:docs];
    [fm changeCurrentDirectoryPath: docs];
    [fm release];
    for (NSString* f in dir)
        if ([[f pathExtension] isEqualToString: @"txt"])
            NSLog(@"%@", f);
}

- (IBAction)doButton8:(id)sender {
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    Person* moi = [[Person alloc] init];
    moi.firstName = @"Matt";
    moi.lastName = @"Neuburg";
    NSData* moidata = [NSKeyedArchiver archivedDataWithRootObject:moi];
    NSString* moifile = [docs stringByAppendingPathComponent:@"moi.txt"];
    [moidata writeToFile:moifile atomically:NO];
    [moi release];
}

- (IBAction)doButton9:(id)sender {
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* moifile = [docs stringByAppendingPathComponent:@"moi.txt"];
    NSData* persondata = [[NSData alloc] initWithContentsOfFile:moifile];
    Person* person = [NSKeyedUnarchiver unarchiveObjectWithData:persondata];
    [persondata release];
    NSLog(@"%@ %@", person.firstName, person.lastName); // Matt Neuburg
}


@end
