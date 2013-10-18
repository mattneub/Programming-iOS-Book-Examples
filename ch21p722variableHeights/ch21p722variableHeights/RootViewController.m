

#import "RootViewController.h"
#import "Cell.h"

@interface RootViewController ()
@property (nonatomic, copy) NSArray* trivia;
@property (nonatomic, strong) NSMutableArray* heights;
@property (nonatomic, strong) Cell* practiceCell;
@end

@implementation RootViewController

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"trivia" withExtension:@"txt"];
    NSString* s = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arr = [[s componentsSeparatedByString:@"\n"] mutableCopy];
    [arr removeLastObject];
    self.trivia = arr;
    
    NSMutableArray* heights = [NSMutableArray new];
    for (int i = 0; i < self.trivia.count; i++)
        [heights addObject: [NSNull null]];
    self.heights = heights;
    
    NSArray* objs = [[UINib nibWithNibName:@"Cell" bundle:nil]
                     instantiateWithOwner:nil options:nil];
    Cell* cell = objs[0];
    self.practiceCell = cell;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellReuseIdentifier:@"Cell"];

    self.tableView.estimatedRowHeight = 40; // new iOS 7 feature
}


- (CGFloat) cellHeightForLabelString:(NSString*)s {
    Cell* cell = self.practiceCell;
    UILabel* lab = cell.lab;
    lab.text = s; // no need to know font, constraints, or anything else about label
    CGFloat h = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
    return ceil(h) + 1;
    // I have no idea why the "+1" is needed, but it is; perhaps there is a rounding error here
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.trivia count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                        forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.lab.text = self.trivia[indexPath.row];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int ix = indexPath.row;
    if ([NSNull null] == self.heights[ix]) {
        NSString* s = self.trivia[ix];
        CGFloat h = [self cellHeightForLabelString:s];
        self.heights[ix] = @(h);
    }
    return [self.heights[ix] floatValue];
}




@end
