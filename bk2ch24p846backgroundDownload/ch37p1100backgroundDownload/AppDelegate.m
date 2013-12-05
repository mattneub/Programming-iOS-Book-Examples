

#import "AppDelegate.h"

@interface AppDelegate () <NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) void (^ch)();
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if (!self.session)
        self.session = [self configureSession];
    return YES;
}

- (void) startDownload: (id) sender {
    NSString* s;
    s = @"http://www.nasa.gov/sites/default/files/styles/1600x1200_autoletterbox/public/pia17474_1.jpg?itok=4fyEwd02";
    NSURLSessionDownloadTask* task = [self.session downloadTaskWithURL:[NSURL URLWithString:s]];
    [task resume];
}

- (NSURLSession*) configureSession {
    NSURLSessionConfiguration* config =
    [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.neuburg.matt.ch37backgroundDownload"];
    config.allowsCellularAccess = NO;
    // ... could set config.discretionary here ...
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    return session;
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat prog = (float)totalBytesWritten/totalBytesExpectedToWrite;
    NSLog(@"downloaded %d%%", (int)(100.0*prog));
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GotProgress" object:self userInfo:@{@"progress":@(prog)}];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    // unused in this example
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData* d = [NSData dataWithContentsOfURL:location];
    UIImage* im = [UIImage imageWithData:d];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = im;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GotPicture" object:self];
    });
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"completed; error: %@", error);
}

// === this is the Really Interesting Part ===

-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    NSLog(@"%@", @"hello hello, storing completion handler");
    self.ch = completionHandler;
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"%@", @"calling completion handler");
    self.ch();
}


							

@end
