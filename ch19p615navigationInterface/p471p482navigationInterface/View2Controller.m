

#import "View2Controller.h"


@implementation View2Controller



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Second";
        UIBarButtonItem* b = [[UIBarButtonItem alloc] 
                              initWithImage:[UIImage imageNamed:@"files.png"]
                              style:UIBarButtonItemStyleBordered target:nil action:nil];
        // Old behavior is: having a left bar button item
        // tromps on the back button
        self.navigationItem.leftBarButtonItem = b;
        
        // However, in iOS 5 there's a new feature that works around this without
        // breaking past apps by throwing a switch
        self.navigationItem.leftItemsSupplementBackButton = YES;
        
        
    }
    return self;
}


@end
