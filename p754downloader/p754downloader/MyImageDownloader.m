

#import "MyImageDownloader.h"

@implementation MyImageDownloader
@synthesize image;

- (void) dealloc {
    [image release];
    [super dealloc];
}

- (UIImage*) image {
    if (image)
        return image;
    [self.connection start];
    return nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.connection = [[[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO] autorelease];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage* im = [UIImage imageWithData:self->receivedData];
    if (im) {
        self.image = im;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageDownloaded" object:self];
    }
}


@end
