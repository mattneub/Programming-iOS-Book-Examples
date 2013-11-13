

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIImageView* iv;
@end

@implementation ViewController

- (IBAction) doSimpleHTTP: (id) sender {
    NSString* s = @"http://www.apeth.net/matt/images/phoenixnewest.jpg";
    NSURL* url = [NSURL URLWithString:s];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@", @"here");
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        NSInteger status = [(NSHTTPURLResponse*)response statusCode];
        NSLog(@"response status: %i", status);
        if (status != 200) {
            NSLog(@"%@", @"oh well");
            return;
        }
        UIImage* im = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.iv.image = im;
            NSLog(@"%@", @"done");
        });
    }];
    [task resume];
}


@end
