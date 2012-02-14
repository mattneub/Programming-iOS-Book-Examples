

#import <Foundation/Foundation.h>


@interface MyXMLParserDelegate : NSObject <NSXMLParserDelegate> 

@property (nonatomic, strong) NSMutableString* text;
@property (nonatomic, weak) MyXMLParserDelegate* parent;
@property (nonatomic, strong) MyXMLParserDelegate* child;
@property (nonatomic, copy) NSString* name;
- (void) start: (NSString*) elementName parent: (id) parent;
- (void) finishedChild: (NSString*) s;
- (void) makeChild: (Class) class elementName: (NSString*) elementName parser: (NSXMLParser*) parser;

@end
