//
//  OtherViewController.m
//  GCDTimerTest
//
//  Created by Matt Neuburg on 1/29/13.
//  Copyright (c) 2013 Matt Neuburg. All rights reserved.
//

#import "OtherViewController.h"

@interface OtherViewController ()
// @property dispatch_source_t timer;
@end

@implementation OtherViewController {
    dispatch_source_t _timer;
}

- (IBAction)doStart:(id)sender {
    self->_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0,0,dispatch_get_main_queue());
    dispatch_source_set_timer(self->_timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self->_timer, ^{
        NSLog(@"%@", self);
    });
    dispatch_resume(self->_timer);
}

- (IBAction)doStop:(id)sender {
    self->_timer = nil;
}

- (IBAction)doDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self->_timer = nil;
}

-(void)dealloc {
    NSLog(@"%@", @"dealloc");
}


@end
