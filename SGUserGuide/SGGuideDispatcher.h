//
//  SGGuideDispatcher.h
//  SGUserGuide
//
//  Created by soulghost on 5/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGGuideNode.h"
#import "SGGuideMaskView.h"

extern NSString * const SGGuideTrigNotification;

@interface SGGuideDispatcher : NSObject

@property (nonatomic, strong) NSArray<SGGuideNode *> *nodes;
@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, strong) UIColor *holeColor;

+ (instancetype)sharedDispatcher;
- (void)next;
- (void)reset;

@end
