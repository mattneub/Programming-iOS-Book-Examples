

#import "ViewController.h"
#import "MyDownloader.h"

@interface ViewController ()
@property (nonatomic, strong) MyDownloader* downloader;
@property (nonatomic, weak) IBOutlet UIImageView* iv;
@end

@implementation ViewController

- (NSURLSessionConfiguration*) configuration {
    NSURLSessionConfiguration* config =
    [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.allowsCellularAccess = NO;
    config.URLCache = nil;
    return config;
}

- (IBAction) doDownload: (id) sender {
    
    if (!self.downloader) {
        MyDownloader* downloader = [[MyDownloader alloc] initWithConfiguration:[self configuration]];
        self.downloader = downloader;
    }
    
    /*
    NSURLSession* session = [self.downloader valueForKey:@"session"];
    [session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        NSLog(@"%@\n%@\n%@", dataTasks, uploadTasks, downloadTasks);
    }];
     */
    
    self.iv.image = nil;
    NSString* s = @"http://www.apeth.net/matt/images/phoenixnewest.jpg";
    s = @"http://www.nasa.gov/sites/default/files/styles/1600x1200_autoletterbox/public/pia17474_1.jpg?itok=4fyEwd02";
    [self.downloader download:s completionHandler:^(NSURL* url){
        if (!url)
            return;
        NSData* d = [NSData dataWithContentsOfURL:url];
        UIImage* im = [UIImage imageWithData:d];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.iv.image = im;
        });
    }];
}

- (void) dealloc {
    if (self->_downloader)
        [self->_downloader cancelAllTasks];
    NSLog(@"%@", @"view controller dealloc");
}


@end
