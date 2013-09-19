

#import "View2Controller.h"


@implementation View2Controller



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Second";
        UIBarButtonItem* b = [[UIBarButtonItem alloc] 
                              initWithImage:[UIImage imageNamed:@"files.png"]
                              style:UIBarButtonItemStylePlain target:nil action:nil];
        // can have both left bar buttons and back bar button
        self.navigationItem.leftBarButtonItem = b;
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
    return self;
}

-(void)viewDidLoad {
    self.view.backgroundColor = [UIColor redColor];
}


@end
