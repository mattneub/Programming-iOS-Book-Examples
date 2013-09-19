

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MyCell : UITableViewCell
@end
@implementation MyCell
-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier {
    // change style
    self = [super initWithStyle:UITableViewCellStyleValue2
                reuseIdentifier:reuseIdentifier];
    return self;
}
@end


@interface GradientView:UIView
@end
@implementation GradientView
+(Class)layerClass { return [CAGradientLayer class]; }
@end

@implementation RootViewController


/*
 So, if we're using the new register-and-dequeue architecture,
 we never call UITableViewCell's initWithStyle.
 So how can we get a built-in style other than UITableViewCellStyleDefault?
 The answer is to set this *in the cell*. We can do this e.g. by supplying a cell class.
 See MyCell.m.
 */

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[MyCell class] forCellReuseIdentifier:@"Cell"];
}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                    forIndexPath:indexPath];
    // cell is never nil, so we need another test for whether we've done common config
    if (cell.backgroundView == nil) {
                
        UIView* v = [UIView new];
        v.backgroundColor = [UIColor blackColor];
        
        // I've changed the way I draw this gradient with rounded corners,
        // and here's why: I'd like to reduce my dependence on fixed frames
        // but if I use a sublayer as I was doing before, I must declare a fixed frame
        // because layers in iOS lack a constraints/autoresizing system
        // but *views* don't lack such a system
        // so instead of a sublayer I'm making a subview of the backgroundView
        // I've declared the entire GradientView class in this class's interface file
        // that's a useful trick for one-shot simple classes
        
        UIView* v2 = [GradientView new];
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
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
//        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping; // UILineBreakModeWordWrap deprecated
//        cell.textLabel.numberOfLines = 2;
        cell.textLabel.textColor = [UIColor whiteColor];
        
        // comment out next lines to see hole punch problem
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    }

    // stuff that is different for each cell goes here
    // okay, in this case it's all the same! but bear with me, it's just an example
    // point is we *could* have a different text and image for each row
    
    cell.textLabel.text = @"Text label";
    cell.detailTextLabel.text = @"Detail text label";
    
    return cell;
}


@end
