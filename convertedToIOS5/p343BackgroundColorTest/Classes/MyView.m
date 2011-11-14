//
//  MyView.m
//  BackgroundColorTest
//
//  Created by Matt Neuburg on 9/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyView.h"


@implementation MyView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

// watch the logs as well as the window as you throw the switch in the running app
// the view is not opaque
// but if its background color is fully opaque, the layer is opaque,
// and hence clearRect results in black instead of punching a hole as it should
// that's the bug

- (void)drawRect:(CGRect)rect {
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(con, [self.backgroundColor CGColor]);
    CGContextFillRect(con, self.bounds);
    CGContextClearRect(con, CGRectInset(self.bounds, 30, 30));
    NSLog(@"layer opaque: %i", (BOOL)[(id)self.layer opaque]);
    NSLog(@"view opaque: %i", self.opaque);
}

- (void)dealloc {
    [super dealloc];
}


@end
