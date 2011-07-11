

#import "MyPeopleParser.h"
#import "MyPersonParser.h"

@implementation MyPeopleParser
@synthesize people;


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString: @"people"])
        self.people = [NSMutableArray array];
    if ([elementName isEqualToString: @"person"]) {
        [self makeChild:[MyPersonParser class] elementName:elementName parser:parser];
    }
}

- (void) finishedChild: (NSString*) s {
    [people addObject: [(MyPersonParser*)self.child person]];
}


@end
