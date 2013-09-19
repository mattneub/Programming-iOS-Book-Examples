

#import "ViewController.h"

@interface ViewController ()
@property (strong) NSData* myBigDataAlias;
@property (nonatomic, strong) NSData* myBigData;
@end

@implementation ViewController

@synthesize myBigDataAlias = _myBigData;

-(void)awakeFromNib {
    [super awakeFromNib];
    // wow, this sure is big data!
    self.myBigData = [@"howdy" dataUsingEncoding:NSUTF8StringEncoding];
}

// tap button to prove we've got big data

- (IBAction)doButton:(id)sender {
    NSString* s = [[NSString alloc] initWithData:self.myBigData encoding:NSUTF8StringEncoding];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Got big data, and it says:" message:s delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

// must override to quiet the compiler and prevent synthesis of myBigData

- (void) setMyBigData: (NSData*) data {
    self.myBigDataAlias = data;
}

// lazy loading

- (NSData*) myBigData {
    if (!self.myBigDataAlias) {
        NSFileManager* fm = [NSFileManager new];
        NSString* f =
        [NSTemporaryDirectory() stringByAppendingPathComponent:@"myBigData"];
        if ([fm fileExistsAtPath:f]) {
            NSLog(@"loading big data from disk");
            self.myBigDataAlias = [NSData dataWithContentsOfFile:f];
            NSError* err = nil;
            BOOL ok = [fm removeItemAtPath:f error:&err];
            NSAssert(ok, @"Couldn't remove temp file");
            NSLog(@"%@", @"deleted big data from disk");
        }
    }
    return self.myBigDataAlias;
}

// to test, run the app in the simulator and trigger a memory warning

- (void)saveAndReleaseMyBigData {
    if (self.myBigData) {
        NSLog(@"unloading big data");
        NSString* f =
        [NSTemporaryDirectory() stringByAppendingPathComponent:@"myBigData"];
        [self.myBigData writeToFile:f atomically:NO];
        self.myBigData = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self saveAndReleaseMyBigData];
}

// backgrounding

-(void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgrounding:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)backgrounding:(NSNotification*)n {
    [self saveAndReleaseMyBigData];
}


@end
