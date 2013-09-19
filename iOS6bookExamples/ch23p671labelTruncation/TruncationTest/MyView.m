//
//  MyView.m
//  TruncationTest
//
//  Created by Matt Neuburg on 1/26/13.
//  Copyright (c) 2013 Matt Neuburg. All rights reserved.
//

#import "MyView.h"

@implementation MyView


- (void)drawRect:(CGRect)rect
{
    [self.text drawInRect:rect];
}

@end
