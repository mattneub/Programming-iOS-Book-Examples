//
//  ViewController.m
//  GCDTimerTest
//
//  Created by Matt Neuburg on 1/29/13.
//  Copyright (c) 2013 Matt Neuburg. All rights reserved.
//

#import "ViewController.h"
#import "OtherViewController.h"

@interface ViewController ()
@end

@implementation ViewController
- (IBAction)doPresent:(id)sender {
    [self presentViewController:[OtherViewController new] animated:YES completion:nil];
}


@end
