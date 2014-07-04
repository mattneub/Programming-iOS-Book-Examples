
#import "ViewController.h"
#import "Player.h"

@interface ViewController()
@property (nonatomic, strong) Player* player;
@end

@implementation ViewController

- (IBAction) doButton: (id) sender {
    NSString* s = [[NSBundle mainBundle] pathForResource:@"Hooded" ofType:@"mp3"];
    [self.player play:s];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.player) {
        Player* p = [[Player alloc] init];
        self.player = p;
    }
}


@end
