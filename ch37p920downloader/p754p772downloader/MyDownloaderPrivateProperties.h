@interface MyDownloader ()
@property (nonatomic, strong, readwrite) NSURLConnection* connection;
@property (nonatomic, copy, readwrite) NSURLRequest* request;
@property (nonatomic, strong, readwrite) NSMutableData* mutableReceivedData;
@end
