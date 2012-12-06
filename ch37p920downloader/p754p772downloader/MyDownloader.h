

#import <Foundation/Foundation.h>


@interface MyDownloader : NSObject 

@property (nonatomic, strong, readonly) NSURLConnection* connection;
@property (nonatomic, strong, readonly) NSData* receivedData;

- (id) initWithRequest: (NSURLRequest*) req;
- (void) cancel;

@end
