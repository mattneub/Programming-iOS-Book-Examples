
/*
 Not in the book. But this seems like a serious omission;
 I should demonstrate minimally how to do a data task, as well as a download task.
 */

#import "ViewController.h"

@interface ViewController () <NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSURLSessionDataTask* task;
@property (nonatomic, weak) IBOutlet UIImageView* iv;
@property (nonatomic, strong) NSMutableData* data;
@end

@implementation ViewController

- (NSURLSession*) configureSession {
    NSURLSessionConfiguration* config =
    [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.allowsCellularAccess = NO;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    return session;
}

- (IBAction) doHTTP: (id) sender {
    if (self.task)
        return;
    if (!self.session)
        self.session = [self configureSession];
    
    NSString* s = @"http://www.apeth.net/matt/images/phoenixnewest.jpg";
    NSURL* url = [NSURL URLWithString:s];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask* task = [[self session] dataTaskWithRequest:req];
    self.task = task;
    self.data = [NSMutableData data];
    self.iv.image = nil;
    [task resume];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"received %lu bytes of data", (unsigned long)data.length);
    // do something with the data here!
    [self.data appendData:data];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"completed; error: %@", error);
    self.task = nil;
    if (!error)
        self.iv.image = [UIImage imageWithData:self.data];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session finishTasksAndInvalidate];
    self.session = nil;
    self.task = nil;
}

-(void)dealloc {
    NSLog(@"%@", @"dealloc");
}

@end
