

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)doButton1:(id)sender {
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", docs);
}

- (IBAction)doButton2:(id)sender {
    NSFileManager* fm = [NSFileManager new];
    NSError* err = nil;
    NSURL* docsurl = [fm URLForDirectory:NSDocumentDirectory
                                inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
    if (docsurl)
        NSLog(@"%@", docsurl);
    else
        NSLog(@"%@", err);
}

- (IBAction)doButton3:(id)sender {
    NSFileManager* fm = [NSFileManager new];
    NSError* err = nil;
    NSURL* suppurl = [fm URLForDirectory:NSApplicationSupportDirectory
                                inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
    if (suppurl)
        NSLog(@"%@", suppurl);
    else
        NSLog(@"%@", err);
}

- (IBAction)doButton4:(id)sender {
    NSFileManager* fm = [NSFileManager new];
    NSURL* docsurl = [fm URLForDirectory:NSDocumentDirectory
                                inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSURL* myfolder = [docsurl URLByAppendingPathComponent:@"MyFolder"];
    NSError* err = nil;
    BOOL ok = [fm createDirectoryAtURL:myfolder withIntermediateDirectories:YES attributes:nil error:&err];
    if (!ok) {
        NSLog(@"%@", err);
        return;
    }
    // if we get here, myfolder exists
    // let's put a couple of files into it
    err = nil;
    ok = [@"howdy" writeToURL:[myfolder URLByAppendingPathComponent:@"file1.txt"] atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!ok) {
        NSLog(@"%@", err);
        return;
    }
    err = nil;
    ok = [@"greetings" writeToURL:[myfolder URLByAppendingPathComponent:@"file2.txt"] atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!ok) {
        NSLog(@"%@", err);
        return;
    }
    NSLog(@"%@", @"ok");
}

- (IBAction)doButton5:(id)sender {
    NSFileManager* fm = [NSFileManager new];
    NSURL* docsurl = [fm URLForDirectory:NSDocumentDirectory
                                inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSError* err = nil;
    NSArray* arr = [fm contentsOfDirectoryAtURL:docsurl includingPropertiesForKeys:nil options:0 error:&err];
    if (!arr) {
        NSLog(@"%@", err);
        return;
    }
    NSLog(@"%@", [arr valueForKey:@"lastPathComponent"]);
}

/*
- (IBAction)doButton6:(id)sender {
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager* fm = [NSFileManager new];
    NSError* err = nil;
    NSArray* arr = [fm subpathsOfDirectoryAtPath:docs error:&err];
    if (!arr) {
        NSLog(@"%@", err);
        return;
    }
    NSLog(@"%@", arr);
}
 */

- (IBAction)doButton7:(id)sender {
    NSFileManager* fm = [NSFileManager new];
    NSURL* docsurl = [fm URLForDirectory:NSDocumentDirectory
                                inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSDirectoryEnumerator* dir = [fm enumeratorAtURL:docsurl includingPropertiesForKeys:nil options:0 errorHandler:nil];
    for (NSURL* f in dir)
        if ([[f pathExtension] isEqualToString: @"txt"])
            NSLog(@"%@", [f lastPathComponent]);
}

- (IBAction)doButton8:(id)sender {
    NSFileManager* fm = [NSFileManager new];
    NSURL* docsurl = [fm URLForDirectory:NSDocumentDirectory
                                inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    Person* moi = [Person new];
    moi.firstName = @"Matt";
    moi.lastName = @"Neuburg";
    NSData* moidata = [NSKeyedArchiver archivedDataWithRootObject:moi];
    NSURL* moifile = [docsurl URLByAppendingPathComponent:@"moi.txt"];
    [moidata writeToURL:moifile atomically:NO];
    NSLog(@"%@", @"ok");
}

- (IBAction)doButton9:(id)sender {
    NSFileManager* fm = [NSFileManager new];
    NSURL* docsurl = [fm URLForDirectory:NSDocumentDirectory
                                inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSURL* moifile = [docsurl URLByAppendingPathComponent:@"moi.txt"];
    NSData* persondata = [[NSData alloc] initWithContentsOfURL:moifile];
    Person* person = [NSKeyedUnarchiver unarchiveObjectWithData:persondata];
    NSLog(@"%@ %@", person.firstName, person.lastName); // Matt Neuburg
}

@end
