

#import <Foundation/Foundation.h>

@interface MyDownloader : NSObject
- (id) initWithConfiguration: (NSURLSessionConfiguration*) config;
- (void) cancelAllTasks;

- (void) download:(NSString*)s completionHandler:(void(^)(NSURL* url))ch;



@end
