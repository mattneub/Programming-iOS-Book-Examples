

#import <Foundation/Foundation.h>


@interface MyDownloader : NSObject {
    NSURLConnection* connection;
    NSURLRequest* request;
    NSMutableData* receivedData;
}
@property (nonatomic, retain) NSURLConnection* connection;
@property (nonatomic, copy) NSURLRequest* request;
@property (nonatomic, retain) NSMutableData* receivedData;
- (id) initWithRequest: (NSURLRequest*) req;
@end
