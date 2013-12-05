

#import "ViewController.h"
#import "View2Controller.h"

@interface ViewController () <UINavigationControllerDelegate>

@end

@implementation ViewController

-(void)awakeFromNib {
    self.title = @"First";
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"key.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(navigate)];
    UIBarButtonItem* b2 = [[UIBarButtonItem alloc]
                           initWithImage:[UIImage imageNamed:@"files.png"]
                           style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[b, b2];
    
    // how to customize back button
    b = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"files.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = b;
}


-(void) navigate {
    View2Controller* v2c = [[View2Controller alloc] init];
    [self.navigationController pushViewController:v2c animated:YES];
}


-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
}

-(NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return UIInterfaceOrientationMaskPortrait;
}



@end
