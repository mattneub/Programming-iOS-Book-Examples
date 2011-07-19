

#import "MyDownloader.h"

@implementation MyDownloader
@synthesize connection, receivedData, request;


- (id) initWithRequest: (NSURLRequest*) req {
    self = [super init];
    if (self) {
        self->request = [req copy];
        self->connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
        self->receivedData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void) dealloc {
    [request release];
    [connection release];
    [receivedData release];
    [super dealloc];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFinished" object:self userInfo:[NSDictionary dictionaryWithObject:error forKey:@"error"]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFinished" object:self];
}


@end
