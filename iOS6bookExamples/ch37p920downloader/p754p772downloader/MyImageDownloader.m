

#import "MyImageDownloader.h"
#import "MyDownloaderPrivateProperties.h"

@interface MyImageDownloader ()
@property (nonatomic, strong) UIImage* image;
@end

@implementation MyImageDownloader

- (UIImage*) image {
    if (self->_image)
        return self->_image;
    [self.connection start];
    return nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage* im = [UIImage imageWithData:self.receivedData];
    if (im) {
        self.image = im;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageDownloaded" object:self];
    }
}

- (void) cancel { // added this
    if (!self.image) // no point cancelling if we did the download
        [super cancel];
}


@end
