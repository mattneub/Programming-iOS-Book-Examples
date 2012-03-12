

#import "MyImageDownloader.h"
#import "MyDownloaderPrivateProperties.h"

@interface MyImageDownloader ()
@property (nonatomic, strong) UIImage* image;
@end

@implementation MyImageDownloader
@synthesize image;

- (UIImage*) image {
    if (image)
        return image;
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


@end
