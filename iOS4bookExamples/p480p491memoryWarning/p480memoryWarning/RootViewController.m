

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, retain) NSData* myBigDataAlias;
@end

@implementation RootViewController
@synthesize myBigDataAlias = myBigData;

- (void)dealloc
{
    [myBigData release];
    [super dealloc];
}

- (IBAction)doButton:(id)sender {
    NSString* s = [[NSString alloc] initWithData:self.myBigData encoding:NSUTF8StringEncoding];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:s message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [s release];
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
    [fm release];
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

- (void) awakeFromNib {
    [super awakeFromNib];
    // this is not really big data, but let's pretend it is
    self.myBigData = [@"howdy" dataUsingEncoding:NSUTF8StringEncoding];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
