

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIImageView* iv;
@end

@implementation ViewController

// more convincing if you run it on a device

- (IBAction) doSimpleHTTP: (id) sender {
    self.iv.image = nil;
    NSString* s = @"http://www.apeth.net/matt/images/phoenixnewest.jpg";
    NSURL* url = [NSURL URLWithString:s];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask* task = [session downloadTaskWithURL:url completionHandler:^(NSURL *loc, NSURLResponse *response, NSError *error) {
        NSLog(@"%@", @"here");
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        NSInteger status = [(NSHTTPURLResponse*)response statusCode];
        NSLog(@"response status: %ld", (long)status);
        if (status != 200) {
            NSLog(@"%@", @"oh well");
            return;
        }
        NSData* d = [NSData dataWithContentsOfURL:loc];
        UIImage* im = [UIImage imageWithData:d];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.iv.image = im;
            NSLog(@"%@", @"done");
        });
    }];
    [task resume];
}


@end
