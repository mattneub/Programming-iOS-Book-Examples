
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, retain) NSData* myBigDataAlias;
@end


@implementation ViewController

@synthesize myBigDataAlias = myBigData;


- (IBAction)doButton:(id)sender {
    NSString* s = [[NSString alloc] initWithData:self.myBigData encoding:NSUTF8StringEncoding];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:s message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [av show];
}

- (void) setMyBigData: (NSData*) data {
    self.myBigDataAlias = data;
}

- (NSData*) myBigData {
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSString* f = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myBigData"];
    BOOL fExists = [fm fileExistsAtPath:f];
    if (!self.myBigDataAlias) {
        if (fExists) {
            NSData* data = [NSData dataWithContentsOfFile:f];
            NSLog(@"loading big data from disk");
            self.myBigDataAlias = data;
            NSError* err = nil;
            BOOL ok = [fm removeItemAtPath:f error:&err];
            NSAssert(ok, @"Couldn't remove temp file");
        }
    }
    return self.myBigDataAlias;
}

// to test, run the app in the simulator and trigger a memory warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self->myBigData) {
        NSLog(@"unloading big data");
        NSString* f = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myBigData"];
        [myBigData writeToFile:f atomically:NO];
        self.myBigData = nil;
    }
}

#pragma mark - View lifecycle

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // this is not really big data, but let's pretend it is
        self.myBigData = [@"howdy" dataUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// note, new in iOS 5 there is also a viewWillUnload callback
// at this time, the view is still valid
// Apple suggests that you might remove views as observers at this point
// (I think this makes sense especially because you could use weak outlets...
// ...and so there will be no need to nilify sibviews manually in viewDidUnload,
// as ARC will miraculously do it for you)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
