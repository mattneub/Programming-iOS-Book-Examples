

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
    
    self.iv.image = nil;
    NSString* s = @"http://www.apeth.net/matt/images/phoenixnewest.jpg";
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
