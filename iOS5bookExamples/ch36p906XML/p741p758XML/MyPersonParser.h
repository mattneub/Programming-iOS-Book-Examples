

#import <Foundation/Foundation.h>
#import "MyXMLParserDelegate.h"
@class Person;

@interface MyPersonParser : MyXMLParserDelegate 

@property (nonatomic, strong) Person* person;

@end
