

#import <Foundation/Foundation.h>
#import "MyXMLParserDelegate.h"
@class Person;

@interface MyPersonParser : MyXMLParserDelegate {

}
@property (nonatomic, retain) Person* person;

@end
