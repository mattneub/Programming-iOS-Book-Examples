

#import <Foundation/Foundation.h>


@interface MyXMLParserDelegate : NSObject <NSXMLParserDelegate> {

}
@property (nonatomic, retain) NSMutableString* text;
@property (nonatomic, assign) MyXMLParserDelegate* parent;
@property (nonatomic, retain) MyXMLParserDelegate* child;
@property (nonatomic, copy) NSString* name;
- (void) start: (NSString*) elementName parent: (id) parent;
- (void) finishedChild: (NSString*) s;
- (void) makeChild: (Class) class elementName: (NSString*) elementName parser: (NSXMLParser*) parser;

@end
