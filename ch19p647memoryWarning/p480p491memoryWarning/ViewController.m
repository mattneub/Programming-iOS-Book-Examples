
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSData* myBigDataAlias;
@property (nonatomic, strong) NSData* myBigData;
@end


@implementation ViewController

@synthesize myBigDataAlias = _myBigData;


- (IBAction)doButton:(id)sender {
    NSString* s = [[NSString alloc] initWithData:self.myBigData encoding:NSUTF8StringEncoding];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:s message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [av show];
}

- (void) setMyBigData: (NSData*) data {
    self.myBigDataAlias = data;
}

- (NSData*) myBigData {
    if (!self.myBigDataAlias) {
        NSFileManager* fm = [[NSFileManager alloc] init];
        NSString* f = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myBigData"];
        BOOL fExists = [fm fileExistsAtPath:f];
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
    if (self->_myBigData) {
        NSLog(@"unloading big data");
        NSString* f = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myBigData"];
        [_myBigData writeToFile:f atomically:NO];
        self.myBigData = nil;
    }
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // this is not really big data, but let's pretend it is
        self->_myBigData = [@"howdy" dataUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}

// note, new in iOS 6 viewWillUnload and viewDidUnload are dead letters
// views are no longer purged! this turns out to have been a mistake all along
// (the *backing store* is purged but that's another story)


@end
