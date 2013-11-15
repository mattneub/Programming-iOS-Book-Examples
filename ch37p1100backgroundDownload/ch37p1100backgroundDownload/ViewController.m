

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIImageView* iv;
@property (nonatomic, weak) IBOutlet UIProgressView* prog;
@end

@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotPicture:) name:@"GotPicture" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotProgress:) name:@"GotProgress" object:nil];
}

- (IBAction) doStart: (id) sender {
    self.prog.progress = 0;
    self.iv.image = nil;
    AppDelegate* del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [del startDownload:self];
}

- (void) grabPicture {
    AppDelegate* del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.iv.image = del.image;
    del.image = nil;
    if (self.iv.image)
        self.prog.progress = 1;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self grabPicture];
}

- (void) gotPicture: (NSNotification*) n {
    [self grabPicture];
}

- (void) gotProgress: (NSNotification*) n {
    NSNumber* prog = n.userInfo[@"progress"];
    self.prog.progress = prog.floatValue;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// tee-hee, thanks Apple

- (IBAction)crash:(id)sender {
	char *c = NULL;
	*c = 1;
}



@end
