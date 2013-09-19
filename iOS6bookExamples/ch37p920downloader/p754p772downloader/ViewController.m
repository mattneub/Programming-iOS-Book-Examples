

#import "ViewController.h"
#import "MyImageDownloader.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray* model;
@end

@implementation ViewController {
    BOOL _added;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_added) {
        _added = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDownloaded:) name:@"imageDownloaded" object:nil];
    }
    NSString* mannyurl = @"http://www.apeth.com/pep/manny.jpg";
    NSString* jackurl = @"http://www.apeth.com/pep/jack.jpg";
    NSString* moeurl = @"http://www.apeth.com/pep/moe.jpg";
    if (!self.model) {
        self.model = [NSMutableArray array];
        for (int ix = 0; ix < 15; ix++) {
            NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:mannyurl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
            MyImageDownloader* idl = [[MyImageDownloader alloc] initWithRequest:req];
            NSDictionary* d = @{@"text": @"Manny", @"pic": idl};
            [self.model addObject: d];
        }
        for (int ix = 15; ix < 30; ix++) {
            NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:moeurl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
            MyImageDownloader* idl = [[MyImageDownloader alloc] initWithRequest:req];
            NSDictionary* d = @{@"text": @"Moe", @"pic": idl};
            [self.model addObject: d];
        }
        for (int ix = 30; ix < 45; ix++) {
            NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:jackurl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
            MyImageDownloader* idl = [[MyImageDownloader alloc] initWithRequest:req];
            NSDictionary* d = @{@"text": @"Jack", @"pic": idl};
            [self.model addObject: d];
        }
    }
}

- (void) imageDownloaded: (NSNotification*) n {
    MyImageDownloader* d = [n object];
    NSUInteger row = [self.model indexOfObjectPassingTest: 
                      ^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                          return (((NSDictionary*)obj)[@"pic"] == d);
                      }];
    if (row == NSNotFound) return; // shouldn't happen
    NSIndexPath* ip = [NSIndexPath indexPathForRow:row inSection:0];
    NSArray* ips = [self.tableView indexPathsForVisibleRows];
    if ([ips indexOfObject:ip] != NSNotFound) {
        [self.tableView reloadRowsAtIndexPaths:@[ip] 
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.model)
        return 0;
    return [self.model count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary* d = (self.model)[indexPath.row];
    cell.textLabel.text = d[@"text"];
    MyImageDownloader* imd = d[@"pic"];
    cell.imageView.image = imd.image;
    return cell;
}

/*
 A thing we didn't grapple with in the previous versions of this example is
 what happens if there are a lot of rows and the user is scrolling fast.
 As each row comes into view, we will ask for its image, and if needed, start downloading.
 But if that row scrolls right back out of view, the download is a waste of resources.
 Let's use a cool new iOS 6 feature to cancel the download in that case.
 */

-(void)tableView:(UITableView *)tableView
didEndDisplayingCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* d = (self.model)[indexPath.row];
    MyImageDownloader* imd = d[@"pic"];
    [imd cancel];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
