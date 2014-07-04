

#import "ViewController.h"

@interface ViewController () <NSURLSessionDownloadDelegate>
@property (nonatomic, weak) IBOutlet UIImageView* iv;
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSURLSessionDownloadTask* task;
@end

@implementation ViewController

- (NSURLSession*) configureSession {
    NSURLSessionConfiguration* config =
    [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.allowsCellularAccess = NO;
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
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    [NSURLProtocol setProperty:@"howdy" forKey:@"greeting" inRequest:req];
    NSURLSessionDownloadTask* task = [[self session] downloadTaskWithRequest:req];
    self.task = task;
    self.iv.image = nil;
    [task resume];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"downloaded %d%%", (int)(100.0*totalBytesWritten/totalBytesExpectedToWrite));
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    // unused in this example
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSURLRequest* req = downloadTask.originalRequest;
    id greeting = [NSURLProtocol propertyForKey:@"greeting" inRequest:req];
    NSLog(@"%@", greeting);
    self.task = nil;
    NSHTTPURLResponse* response = (NSHTTPURLResponse*)downloadTask.response;
    NSInteger stat = response.statusCode;
    NSLog(@"status %ld", (long)stat);
    if (stat != 200)
        return;
    NSData* d = [NSData dataWithContentsOfURL:location];
    UIImage* im = [UIImage imageWithData:d];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.iv.image = im;
    });
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"completed; error: %@", error);
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session finishTasksAndInvalidate];
    self.session = nil;
}

-(void)dealloc {
    NSLog(@"%@", @"dealloc");
}



@end
