//
//  MyTableViewCell.m
//  p597timeConsumingNavigation
//
//  Created by Matt Neuburg on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyTableViewCell.h"


@implementation MyTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        UIActivityIndicatorView* v = 
        [[UIActivityIndicatorView alloc] 
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        v.center = 
        CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        v.tag = 1001;
        [self.contentView addSubview:v];
        [v startAnimating];
        [v release];
    } else {
        [[self.contentView viewWithTag:1001] removeFromSuperview];
        // no harm if nonexistent
    }
    [super setSelected:selected animated:animated];
}

@end
