

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation RootViewController
@synthesize tvc;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

#define which 1 // try 2 to use iOS 5 new automatic cell nib loading

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    switch (which) {
        case 1: break;
            // note! this is not where we'd usually do this!
            // I'm just doing it here to make it easy to switch with "which"
            // see p516 example where I do it properly in initWithNibName
        case 2: [tableView registerNib:[UINib nibWithNibName:@"MyCell2" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            // note that the MyCell2 nib is identical to MyCell...
            // except that it has no outlet! an outlet will crash us,
            // because the nib's owner will be an NSObject without a matching ivar
    }

    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSLog(@"here"); // under case 2, this code never runs!
        
        // load nib with efficient caching (this was new in iOS 4)
        UINib* theCellNib = [UINib nibWithNibName:@"MyCell" bundle:nil];
        [theCellNib instantiateWithOwner:self options:nil];
        cell = self.tvc;
        self.tvc = nil;
        
    }
    
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
