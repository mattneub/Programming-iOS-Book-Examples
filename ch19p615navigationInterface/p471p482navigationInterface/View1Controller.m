

#import "View1Controller.h"
#import "View2Controller.h"


@implementation View1Controller


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"First";
        UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"key.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(navigate)];
        // self.navigationItem.rightBarButtonItem = b;
        // new iOS 5 feature: buttons can be assigned in arrays, meaning you can have multiple
        // left and right buttons
        // note that the right bar button items go from right to left
        // so the first one you give is the one that should navigation right, if any does
        UIBarButtonItem* b2 = [[UIBarButtonItem alloc] 
                              initWithImage:[UIImage imageNamed:@"files.png"]
                              style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.rightBarButtonItems = @[b, b2];
        
        
        // uncomment these lines and see what happens (see p. 620)
//        b = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"files.png"] style:UIBarButtonItemStyleBordered target:nil action:nil];
//        self.navigationItem.backBarButtonItem = b;
    }
    return self;
}

-(void) navigate {
    View2Controller* v2c = [[View2Controller alloc] init];
    [self.navigationController pushViewController:v2c animated:YES];
}

@end
