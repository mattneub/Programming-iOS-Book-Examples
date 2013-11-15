

#import "MyDownloader.h"

@interface MyDownloader() <NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURLSession* session;
@end

@implementation MyDownloader

- (id) initWithConfiguration: (NSURLSessionConfiguration*) config {
    self = [super init];
    if (self) {
        NSURLSession* session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        self->_session = session;
    }
    return self;
}

- (NSURLSessionTask*) download:(NSString*)s completionHandler:(void(^)(NSURL* url))ch {
    NSURL* url = [NSURL URLWithString:s];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    [NSURLProtocol setProperty:ch forKey:@"ch" inRequest:req];
    NSURLSessionDownloadTask* task = [self.session downloadTaskWithRequest:req];
    [task resume];
    return task;
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"downloaded %d%%", (int)(100.0*totalBytesWritten/totalBytesExpectedToWrite));
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    // unused in this example
    NSLog(@"%@", @"did resume");
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSURLRequest* req = downloadTask.originalRequest;
    void(^ch)(NSURL* url) = [NSURLProtocol propertyForKey:@"ch" inRequest:req];
    NSHTTPURLResponse* response = (NSHTTPURLResponse*)downloadTask.response;
    NSInteger stat = response.statusCode;
    NSLog(@"status %i", stat);
    NSURL* url = nil;
    if (stat == 200) {
        url = location;
        NSLog(@"downloaded %@", req.URL.lastPathComponent);
    }
    ch(url);
}

- (void) cancelAllTasks {
    [self.session invalidateAndCancel];
}

- (void) dealloc {
    NSLog(@"%@", @"MyDownloader dealloc");
}



@end
