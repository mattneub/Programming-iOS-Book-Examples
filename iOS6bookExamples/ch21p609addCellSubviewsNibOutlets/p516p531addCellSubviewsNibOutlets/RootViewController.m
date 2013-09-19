

#import "RootViewController.h"
#import "MyCell.h"
#import <QuartzCore/QuartzCore.h>

@interface GradientView:UIView
@end
@implementation GradientView
+(Class)layerClass {
    return [CAGradientLayer class];
}
@end


@implementation RootViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil]
         forCellReuseIdentifier:@"Cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

// same as previous example
// except now we have outlets so we can refer to the cell's subviews using names instead of numbers
// of course this works just the same if the table and cell come from a storyboard
// all very nice and neat

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCell* cell = (MyCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
        
    if (!cell.backgroundView) {
        UIView* v = [[UIView alloc] init];
        v.backgroundColor = [UIColor blackColor];
        UIView* v2 = [[GradientView alloc] init];
        CAGradientLayer* lay = (CAGradientLayer*)v2.layer;
        lay.colors = @[(id)[UIColor colorWithWhite:0.6 alpha:1].CGColor,
        (id)([UIColor colorWithWhite:0.4 alpha:1].CGColor)];
        lay.borderWidth = 1;
        lay.borderColor = [UIColor blackColor].CGColor;
        lay.cornerRadius = 5;
        [v addSubview:v2];
        v2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        // or you could do the same thing with constraints, but there is no need
        cell.backgroundView = v;
    }
    
    UILabel* lab = cell.theLabel; // name instead of number
    // ... set up lab here ...
    // notice how much less of this there now is, because it's mostly done in the nib
    lab.text = @"The author of this book, who would rather be out dirt biking";
    
    // interesting change: in the prev editions I was using the property name "imageView"
    // this overlapped with existing name but gave us no problem
    // now it does :) so had to change the name
    UIImageView* iv = cell.theImageView; // name instead of number
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
