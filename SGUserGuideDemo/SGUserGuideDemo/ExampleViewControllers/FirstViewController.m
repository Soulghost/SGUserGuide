//
//  FirstViewController.m
//  SGUserGuideDemo
//
//  Created by soulghost on 5/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "FirstViewController.h"
#import "SGGuideDispatcher.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface UIViewWrap : NSObject

@property (nonatomic, weak) UIView *innerView;

@end

@implementation UIViewWrap

@end

@interface FirstViewController ()

@property (nonatomic, weak) UIButton *addBtn;
@property (nonatomic, strong) UIViewWrap *wrap;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addBtn.center = CGPointMake(100, 100);
    self.addBtn = addBtn;
    [addBtn addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    pushBtn.center = CGPointMake(200, 400);
    UIViewWrap *wrap = [UIViewWrap new];
    wrap.innerView = pushBtn;
    self.wrap = wrap;
    [pushBtn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBtn];
}

- (void)showAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You Option" message:@"What's your option?" delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertView.delegate = self;
    [alertView show];
}

- (void)push {
    UITabBarController *tb = [[UITabBarController alloc] init];
    SecondViewController *secondVc = [SecondViewController new];
    secondVc.title = @"Second";
    secondVc.tabBarItem.image = [UIImage imageNamed:@"Second"];
    ThirdViewController *thirdVc = [ThirdViewController new];
    thirdVc.title = @"Third";
    thirdVc.tabBarItem.image = [UIImage imageNamed:@"Third"];
    tb.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:secondVc],
                           [[UINavigationController alloc] initWithRootViewController:thirdVc]
                           ];
    [self presentViewController:tb animated:YES completion:nil];
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        SGGuideDispatcher *dp = [SGGuideDispatcher sharedDispatcher];
        [dp next];
    }
}

@end
