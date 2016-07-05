//
//  SGGuideDispatcher.m
//  SGUserGuide
//
//  Created by soulghost on 5/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <objc/runtime.h>
#import "SGGuideDispatcher.h"
#import "SGGuideMaskView.h"

NSString * const SGGuideTrigNotification = @"SGGuideTrigNotification";
NSString * const kSGGuideDispatcherCur = @"kSGGuideDispatcherCur";

@interface SGGuideDispatcher ()

@property (nonatomic, assign) NSInteger cur;
@property (nonatomic, weak) UIViewController *currentViewController;

@end

@implementation SGGuideDispatcher

+ (instancetype)sharedDispatcher {
    static SGGuideDispatcher *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.holeColor = [UIColor clearColor];
        self.maskColor = [UIColor colorWithWhite:0.6f alpha:0.8f];
    }
    return self;
}

- (void)next {
    if (!self.currentViewController) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:SGGuideTrigNotification object:@{@"viewController":self.currentViewController}];
}

+ (void)load {
    [SGGuideDispatcher sharedDispatcher];
}

- (void)reset {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kSGGuideDispatcherCur];
    self.cur = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trig:) name:SGGuideTrigNotification object:nil];
}

- (void)setNodes:(NSArray<SGGuideNode *> *)nodes {
    _nodes = nodes;
    self.cur = [[NSUserDefaults standardUserDefaults] integerForKey:kSGGuideDispatcherCur];
    if (self.cur < nodes.count) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trig:) name:SGGuideTrigNotification object:nil];
    }
}

- (void)trig:(NSNotification *)nof {
    if (self.cur >= self.nodes.count) return;
    SGGuideMaskView *maskView = [SGGuideMaskView sharedMask];
    UIViewController *topVc = nof.object[@"viewController"];
    SGGuideNode *node = self.nodes[self.cur];
    if ([topVc isKindOfClass:node.controllerClass]) {
        self.currentViewController = topVc;
        [maskView hide];
        self.cur++;
        [[NSUserDefaults standardUserDefaults] setInteger:self.cur forKey:kSGGuideDispatcherCur];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (node.permitViewPath == nil) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            return;
        }
        maskView.node = node;
        [maskView showInViewController:topVc];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
