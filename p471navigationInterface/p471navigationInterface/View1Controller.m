

#import "View1Controller.h"
#import "View2Controller.h"


@implementation View1Controller

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"First";
        UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"key.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(navigate)];
        self.navigationItem.rightBarButtonItem = b;
        [b release];
        // uncomment these lines and see what happens (see p. 470)
//        b = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"files.png"] style:UIBarButtonItemStyleBordered target:nil action:nil];
//        self.navigationItem.backBarButtonItem = b;
//        [b release];
    }
    return self;
}

-(void) navigate {
    View2Controller* v2c = [[View2Controller alloc] init];
    [self.navigationController pushViewController:v2c animated:YES];
    [v2c release];
}

@end
