//
//  AppDelegate.m
//  CodeDemo
//
//  Created by YangXiao on 2020/8/7.
//  Copyright © 2020 YangXiao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    self.window.rootViewController = [[ViewController alloc] init];;
    
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark - UISceneSession lifecycle



@end
