

#import "RootViewController.h"
#import "MyCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation RootViewController
@synthesize tvc;

static NSString *CellIdentifier = @"Cell";

// this is obviously a much better place to call registerNib - once and done

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

// same as second version of p 515 example
// except now we have outlets so we can refer to the cell's subviews using names instead of numbers
// of course this works just the same if the table and cell come from a storyboard
// all very nice and neat

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCell* cell = (MyCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    // moved to here, but with a test so we don't do it for already configured cells
    if (!cell.backgroundView) {
        UIView* v = [[UIView alloc] initWithFrame:cell.frame];
        v.backgroundColor = [UIColor blackColor];
        CAGradientLayer* lay = [CAGradientLayer layer];
        lay.colors = [NSArray arrayWithObjects: 
                      (id)[UIColor colorWithWhite:0.6 alpha:1].CGColor, 
                      [UIColor colorWithWhite:0.4 alpha:1].CGColor, nil];
        lay.frame = v.layer.bounds;
        [v.layer addSublayer:lay];
        lay.borderWidth = 1;
        lay.borderColor = [UIColor blackColor].CGColor;
        lay.cornerRadius = 5;
        cell.backgroundView = v;
    }
    
    UILabel* lab = cell.label; // name instead of number
    // ... set up lab here ...
    // notice how much less of this there now is, because it's mostly done in the nib
    lab.text = @"The author of this book, who would rather be out dirt biking";
    
    UIImageView* iv = cell.imageView; // name instead of number
    // ... set up iv here ...
    UIImage* im = [UIImage imageNamed:@"moi.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36,36), YES, 0.0);
    [im drawInRect:CGRectMake(0,0,36,36)];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    iv.image = im2;

    return cell;
}





@end
