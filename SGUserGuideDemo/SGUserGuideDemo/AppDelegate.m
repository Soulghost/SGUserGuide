//
//  AppDelegate.m
//  SGUserGuideDemo
//
//  Created by soulghost on 5/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideHeader.h"
#import "SGGuideDispatcher.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupGuide];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [FirstViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupGuide {
    SGGuideDispatcher *dp = [SGGuideDispatcher sharedDispatcher];
    [dp reset];
    dp.nodes = @[
                 [SGGuideNode nodeWithController:[FirstViewController class] permitViewPath:@"addBtn" message:@"Please Click The Add Button And Choose Yes From the Alert." reverse:NO],
                 [SGGuideNode nodeWithController:[FirstViewController class] permitViewPath:@"wrap.innerView" message:@"Please Click the Info Button" reverse:NO],
                 [SGGuideNode nodeWithController:[SecondViewController class] permitViewPath:@"tabBarController.tabBar" message:@"Please Change To Third Page" reverse:NO],
                 [SGGuideNode endNodeWithController:[ThirdViewController class]]
                 ];
}

@end
