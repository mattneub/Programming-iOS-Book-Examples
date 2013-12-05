//
//  ViewController.m
//  LayoutEventTest
//
//  Created by Matt Neuburg on 9/1/13.
//  Copyright (c) 2013 Matt Neuburg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"%@ willMove to %@", self, parent);
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"%@ didMove to %@", self, parent);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@ willAppear", self);
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@ didAppear", self);
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@ willDisappear", self);
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@ didDisappear", self);
}

-(void)viewWillLayoutSubviews {
    NSLog(@"%@ will layout", self);
}

-(void)viewDidLayoutSubviews {
    NSLog(@"%@ did layout", self);
}

-(void)updateViewConstraints {
    NSLog(@"%@ update constraints", self);
    [super updateViewConstraints];
}



@end
