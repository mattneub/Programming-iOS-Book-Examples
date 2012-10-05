

#import "MyDownloader.h"
#import "MyDownloaderPrivateProperties.h"

@implementation MyDownloader
@synthesize connection=_connection;
@synthesize request=_request;
@synthesize mutableReceivedData=_mutableReceivedData;

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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFinished" object:self userInfo:[NSDictionary dictionaryWithObject:error forKey:@"error"]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFinished" object:self];
}


@end
