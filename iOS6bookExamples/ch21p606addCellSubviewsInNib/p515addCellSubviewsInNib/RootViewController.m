

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GradientView:UIView
@end
@implementation GradientView
+(Class)layerClass {
    return [CAGradientLayer class];
}
@end


@interface RootViewController()
@end

@implementation RootViewController

/*
 I've eliminated the earlier alternative version where we loaded the cell nib ourselves
 and accessed the cell through a property; that version is pointless now that registration
 is the standard form of the cell dequeue mechanism
 */

- (void)viewDidLoad {
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

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
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
    
    UILabel* lab = (UILabel*)[cell viewWithTag: 2];
    // ... set up lab here ...
    // notice how much less of this there now is, because it's mostly done in the nib
    lab.text = @"The author of this book, who would rather be out dirt biking";
    
    UIImageView* iv = (UIImageView*)[cell viewWithTag: 1];
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
