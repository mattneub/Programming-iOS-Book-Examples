

#import "ViewController.h"

@interface ViewController () <NSURLSessionDataDelegate>
@property (nonatomic, strong) NSMutableData* data;
@property (nonatomic, weak) IBOutlet UIImageView* iv;
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSURLSessionDataTask* task;
@end

@implementation ViewController

- (NSURLSession*) configureSession {
    NSURLSessionConfiguration* config =
    [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    return session;
}

- (IBAction) doElaborateHTTP: (id) sender {
    if (self.task)
        return;
    if (!self.session)
        self.session = [self configureSession];
    
    NSString* s = @"http://www.apeth.net/matt/images/phoenixnewest.jpg";
    NSURL* url = [NSURL URLWithString:s];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask* task = [[self session] dataTaskWithRequest:req];
    self.task = task;
    self.iv.image = nil;
    [task resume];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    self.data = [NSMutableData data];
    NSInteger status = [(NSHTTPURLResponse*)response statusCode];
    NSLog(@"got response: %d", status);
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"%@", @"got some data");
    [self.data appendData:data];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    self.task = nil;
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    UIImage* im = [UIImage imageWithData:self.data];
    self.iv.image = im;
    NSLog(@"%@", @"done!");
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session finishTasksAndInvalidate];
}

-(void)dealloc {
    NSLog(@"%@", @"dealloc");
}



@end
