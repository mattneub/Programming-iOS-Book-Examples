

#import "RootViewController.h"
#import "Cell.h"

@interface RootViewController () <UITableViewDataSource>
@property (nonatomic, copy) NSArray* trivia;
@property (nonatomic, copy) NSArray* heights;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Trivia";
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"trivia" withExtension:@"txt"];
    NSString* s = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arr = [[s componentsSeparatedByString:@"\n"] mutableCopy];
    [arr removeLastObject];
    self.trivia = arr;
    
    // hard-coded dimensions, sorry about this
    // a better way might be nice
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:14];
    NSMutableArray* heights = [NSMutableArray arrayWithCapacity:[arr count]];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString* s = obj;
        CGFloat h = [s sizeWithFont:font
                  constrainedToSize:CGSizeMake(300,30000)
                      lineBreakMode:NSLineBreakByWordWrapping].height;
        h += 13*2;
        [heights insertObject:@(h) atIndex:idx];
    }];
    self.heights = heights;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.trivia count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell* cell = (Cell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    cell.lab.text = self.trivia[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.heights[indexPath.row] floatValue];
}


@end
