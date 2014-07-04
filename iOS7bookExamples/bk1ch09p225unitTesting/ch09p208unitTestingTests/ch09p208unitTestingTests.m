
#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface ch09p208unitTestingTests : XCTestCase
@property ViewController* viewController;
@end

@implementation ch09p208unitTestingTests

- (void)setUp
{
    [super setUp];
    self.viewController = [ViewController new];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testDogMyCats {
    NSString* input = @"cats";
    XCTAssertEqualObjects([self.viewController dogMyCats:@"cats"], @"dogs",
                          @"ViewController dogMyCats: fails to produce dogs from \"%@\"",
                          input);
}

@end
