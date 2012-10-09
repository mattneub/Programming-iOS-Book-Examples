//
//  AppDelegate.m
//  p299p308bounds
//
//  Created by Matt Neuburg on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#define which 1 // change "1" to "2" or "3" to generate the other figures

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    
    switch (which) {
        case 1: 
        {
            // figure 14-3
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(113, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:CGRectInset(v1.bounds, 10, 10)];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [self.window.rootViewController.view addSubview: v1];
            [v1 addSubview: v2];
            break;
        }
        case 2:
        {
            // figure 14-4
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(113, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:CGRectInset(v1.bounds, 10, 10)];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [self.window.rootViewController.view addSubview: v1];
            [v1 addSubview: v2];
            CGRect f = v2.bounds;
            f.size.height += 20;
            f.size.width += 20;
            v2.bounds = f;
            break;
        }
        case 3:
        {
            // figure 14-5
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(113, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:CGRectInset(v1.bounds, 10, 10)];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [self.window.rootViewController.view addSubview: v1];
            [v1 addSubview: v2];
            CGRect f = v1.bounds;
            f.origin.x += 10;
            f.origin.y += 10;
            v1.bounds = f;
            break;
        }
    }

    
    
    
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
