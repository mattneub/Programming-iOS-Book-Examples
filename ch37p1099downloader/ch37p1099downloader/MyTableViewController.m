

#import "MyTableViewController.h"
#import "MyDownloader.h"

@interface MyTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray* model;
@property (nonatomic, strong) MyDownloader* downloader;
@end

@implementation MyTableViewController

- (NSURLSessionConfiguration*) configuration {
    NSURLSessionConfiguration* config =
    [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.allowsCellularAccess = NO;
    config.URLCache = nil;
    return config;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.downloader) {
        MyDownloader* downloader = [[MyDownloader alloc] initWithConfiguration:[self configuration]];
        self.downloader = downloader;
    }
    if (self.model)
        return;
    NSString* mannyurl = @"http://www.apeth.com/pep/manny.jpg";
    NSString* jackurl = @"http://www.apeth.com/pep/jack.jpg";
    NSString* moeurl = @"http://www.apeth.com/pep/moe.jpg";
    self.model = [NSMutableArray array];
    
    for (int ix = 0; ix < 15; ix++) {
        NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:@{@"text": @"Manny", @"pic": mannyurl}];
        [self.model addObject: d];
    }
    for (int ix = 15; ix < 30; ix++) {
        NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:@{@"text": @"Moe", @"pic": moeurl}];
        [self.model addObject: d];
    }
    for (int ix = 30; ix < 45; ix++) {
        NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:@{@"text": @"Jack", @"pic": jackurl}];
        [self.model addObject: d];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSMutableDictionary* d = (self.model)[indexPath.row];
    cell.textLabel.text = d[@"text"];
    // have we got a picture?
    id pic = d[@"pic"];
    if ([pic isKindOfClass:[UIImage class]]) {
        cell.imageView.image = pic;
    } else if ([pic isKindOfClass:[NSString class]]) {
        cell.imageView.image = nil;
        [self.downloader download:pic completionHandler:^(NSURL* url){
            if (!url)
                return;
            NSData* data = [NSData dataWithContentsOfURL:url];
            UIImage* im = [UIImage imageWithData:data];
            d[@"pic"] = im;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        }];
    }
    return cell;
}

- (void) dealloc {
    if (self->_downloader)
        [self->_downloader cancelAllTasks];
    NSLog(@"%@", @"table view controller dealloc");
}



@end
