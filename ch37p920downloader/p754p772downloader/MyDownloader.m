

#import "MyDownloader.h"
#import "MyDownloaderPrivateProperties.h"

@implementation MyDownloader

- (NSData*) receivedData {
    return [self.mutableReceivedData copy];
}

- (id) initWithRequest: (NSURLRequest*) req {
    self = [super init];
    if (self) {
        self->_request = [req copy];
        self->_connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
        self->_mutableReceivedData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.mutableReceivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.mutableReceivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFinished" object:self userInfo:@{@"error": error}];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFinished" object:self];
}

- (void) cancel { // added this
    // cancel download in progress, replace connection, start over
    [self.connection cancel];
    self->_connection = [[NSURLConnection alloc] initWithRequest:self->_request
                                                        delegate:self
                                                startImmediately:NO];
}


@end
