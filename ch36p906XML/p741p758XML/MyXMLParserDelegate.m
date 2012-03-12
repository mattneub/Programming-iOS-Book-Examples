

#import "MyXMLParserDelegate.h"


@implementation MyXMLParserDelegate
@synthesize text, parent, child, name;

- (void) start: (NSString*) el parent: (id) p {
    self.name = el;
    self.parent = p;
    self.text = [NSMutableString string];
}

- (void) makeChild: (Class) class elementName: (NSString*) elementName parser: (NSXMLParser*) parser {
    MyXMLParserDelegate* del = [[class alloc] init];
    self.child = del;
    parser.delegate = del;
    [del start: elementName parent: self];
}

- (void) finishedChild: (NSString*) s { // subclass implements as desired
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.text appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (parent) {
        [parent finishedChild: [self.text copy]];
        parser.delegate = self.parent;
    }
}



@end
