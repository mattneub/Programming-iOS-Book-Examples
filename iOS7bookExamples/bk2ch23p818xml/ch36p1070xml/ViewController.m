

#import "ViewController.h"
#import "MyPeopleParser.h"

@interface ViewController ()

@end

@implementation ViewController

// if this works, you'll see a list of people appear in the console

- (IBAction) doButton: (id) sender {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"folks" withExtension:@"xml"];
    NSXMLParser* parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    MyPeopleParser* people = [MyPeopleParser new];
    [parser setDelegate: people];
    [parser parse];
    
    // ... do something with people.people ...
    NSLog(@"%@", people.people);
}


@end
