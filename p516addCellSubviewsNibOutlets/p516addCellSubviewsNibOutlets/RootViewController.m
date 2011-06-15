

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MyCell.h"

@implementation RootViewController
@synthesize tvc;
@synthesize titles;

- (void) awakeFromNib {
    [super awakeFromNib];
    NSMutableArray* marr = [NSMutableArray array];
    for (int i = 0; i<100; i++)
        [marr addObject: [NSString stringWithFormat: @"This is row %i of section 0", i]];
    self.titles = [NSArray arrayWithArray: marr];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100; // making 100 rows this time
}

#define which 1 // try also "2", same result but more like the way you'll supply real-life data

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // in iOS 4, really should be using UINib to load nib repeatedly like this
        UINib* theCellNib = [UINib nibWithNibName:@"MyCell" bundle:nil]; 
        [theCellNib instantiateWithOwner:self options:nil];        
        cell = self.tvc;
        NSLog(@"creating a new cell"); // let's log to see how often cells are actually created
                                       // we appear to have 100 rows...
                                       // but logging shows that we make only 11 cells
    }
    
    MyCell* theCell = (MyCell*)cell; // cast as MyCell, use properties
    
    UILabel* lab = theCell.theLabel; // possibly nicer than viewWithTag:
    // ... set up lab here ...
    // p. 521, giving each cell its own content
    switch (which) {
        case 1:
        {
            lab.text = [NSString stringWithFormat: @"This is row %i of section %i",
                        indexPath.row, indexPath.section];
            break;
        }
        case 2:
        {
            // in real life, you'll almost always pull the data out of a model object
            // such as an array whose rows correspond to the table rows in some way
            lab.text = [titles objectAtIndex: [indexPath row]];
            break;
        }
    }
    
    UIImageView* iv = theCell.theImageView; // possibly nicer than viewWithTag:
    // ... set up iv here ...
    UIImage* im = [UIImage imageNamed:@"moi.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(35,35), YES, 0.0);
    [im drawInRect:CGRectMake(0,0,35,35)];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    iv.image = im2;
    iv.contentMode = UIViewContentModeCenter;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView 
  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![cell.layer valueForKey:@"done"]) {
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
        [v release];
        [cell.layer setValue:@"done" forKey:@"done"];
    }
}

// p. 529, mess with selection behavior

- (NSIndexPath*) tableView:(UITableView*)tv 
  willSelectRowAtIndexPath:(NSIndexPath*)ip {
    if ([tv cellForRowAtIndexPath:ip].selected) {
        [tv deselectRowAtIndexPath:ip animated:NO];
        return nil;
    }
    return ip;
}

- (NSIndexPath*) tableView:(UITableView*)tv 
willDeselectRowAtIndexPath:(NSIndexPath*)ip {
    return nil;
}


- (void)dealloc
{
    [titles release];
    [super dealloc];
}

@end
