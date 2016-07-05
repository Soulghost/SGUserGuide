//
//  SGGuideMaskView.h
//  SGUserGuide
//
//  Created by soulghost on 5/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGGuideNode;

@interface SGGuideMaskView : UIView

@property (nonatomic, strong) SGGuideNode *node;
@property (nonatomic, weak) UILabel *messageLabel;

+ (instancetype)sharedMask;
- (void)showInViewController:(UIViewController *)viewController;
- (void)hide;

@end
