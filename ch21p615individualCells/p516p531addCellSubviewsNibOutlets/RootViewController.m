

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
    return 100; // to prove efficiency, we'll make a "big" table
}

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
        
        // we will log to see how many cell objects are really being created
        NSLog(@"creating a new cell"); // only about a dozen cells are created...
    }
    
    UILabel* lab = cell.theLabel;
    // okay, this is the really interesting part!
    lab.text = [NSString stringWithFormat:@"This is row %i of section %i",
                indexPath.row, indexPath.section];
    // ... the table looks like it consists of 100 individual rows
    
    
    UIImageView* iv = cell.theImageView;
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
