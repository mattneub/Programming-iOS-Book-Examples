

#import "MyPersonParser.h"
#import "Person.h"

@implementation MyPersonParser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    [self makeChild:[MyXMLParserDelegate class] elementName:elementName parser:parser];
}

- (void) finishedChild:(NSString *)s {
    if (!self.person) {
        Person* p = [Person new];
        self.person = p;
    }
    [self.person setValue: s forKey: self.child.name];
}



@end
