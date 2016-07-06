//
//  SGGuideMaskView.m
//  SGUserGuide
//
//  Created by soulghost on 5/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGGuideDispatcher.h"
#import "SGGuideMaskView.h"
#import "SGGuideNode.h"

#define Rect(v) [NSValue valueWithCGRect:v]

@interface SGGuideMaskView ()

@property (nonatomic, weak) UIView *permitView;
@property (nonatomic, assign) CGRect permitRect;
@property (nonatomic, assign) CGRect permitViewFrame;

@end

@implementation SGGuideMaskView

+ (instancetype)sharedMask {
    static SGGuideMaskView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
        UILabel *messageLabel = [UILabel new];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.layer.cornerRadius = 4.0f;
        messageLabel.layer.masksToBounds = YES;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.numberOfLines = 0;
        messageLabel.backgroundColor = [UIColor lightGrayColor];
        messageLabel.font = [UIFont boldSystemFontOfSize:14];
        self.messageLabel = messageLabel;
        self.textMargin = 5;
        [self addSubview:messageLabel];
    }
    return self;
}

- (void)showInViewController:(UIViewController *)viewController {
    [self hide];
    self.permitView = [viewController valueForKeyPath:self.node.permitViewPath];
    self.messageLabel.text = self.node.message;
    if (viewController.tabBarController) {
        [viewController.tabBarController.view addSubview:self];
    }else if (viewController.navigationController) {
        [viewController.navigationController.view addSubview:self];
    } else {
        [viewController.view addSubview:self];
    }
    self.frame = self.superview.frame;
    [self setNeedsDisplay];
}

- (void)hide {
    [self removeFromSuperview];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL ret = !CGRectContainsPoint(self.permitRect, point);
    if (self.node.reverse) {
        ret = !ret;
    }
    return ret;
}

- (void)drawRect:(CGRect)rect {
    UIColor *maskColor = nil;
    UIColor *holeColor = nil;
    SGGuideDispatcher *dp = [SGGuideDispatcher sharedDispatcher];
    if (!self.node.reverse) {
        maskColor = dp.maskColor;
        holeColor = dp.holeColor;
    } else {
        maskColor = dp.holeColor;
        holeColor = dp.maskColor;
    }
    [maskColor setFill];
    UIRectFill(rect);
    // There are some itmes which are not UIView's subclass
    if (![self.permitView isKindOfClass:[UIView class]]) {
        // navigationItem.leftBarButtonItem
        // navigationItem.rightBarButtonItem
        NSString *path = self.node.permitViewPath;
        NSString *itemName = [[path componentsSeparatedByString:@"."] lastObject];
        CGRect permitRect = CGRectZero;
        UIViewController *currentVc = [SGGuideDispatcher sharedDispatcher].currentViewController;
        CGRect navBarFrame = currentVc.navigationController.navigationBar.frame;
        if ([itemName isEqualToString:@"leftBarButtonItem"]) {
            permitRect.size = CGSizeMake(navBarFrame.size.width * 0.5f, navBarFrame.size.height);
            permitRect.origin = navBarFrame.origin;
        } else if ([itemName isEqualToString:@"rightBarButtonItem"]) {
            permitRect.size = CGSizeMake(navBarFrame.size.width * 0.5f, navBarFrame.size.height);
            permitRect.origin = CGPointMake(navBarFrame.size.width * 0.5f, navBarFrame.origin.y);
        }
        self.permitViewFrame = permitRect;
    } else {
        self.permitViewFrame = [self.permitView convertRect:self.permitView.bounds toView:self];
    }
    self.permitRect = CGRectIntersection(self.permitViewFrame, rect);
    [holeColor setFill];
    UIRectFill(self.permitRect);
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize visibleSize = self.frame.size;
    CGFloat holeX = self.permitRect.origin.x;
    CGFloat holeY = self.permitRect.origin.y;
    CGFloat holeW = self.permitRect.size.width;
    CGFloat holeH = self.permitRect.size.height;
    // choose region
    NSArray *regions = @[Rect(CGRectMake(0, 0, holeX + holeW, holeY)),
                         Rect(CGRectMake(holeX + holeW, 0, visibleSize.width - holeX, holeY)),
                         Rect(CGRectMake(0, holeY + holeH, holeX + holeW, visibleSize.height - holeY - holeH)),
                         Rect(CGRectMake(holeX + holeW, holeY + holeH, visibleSize.width - holeX, visibleSize.height - holeY - holeH))
                         ];
    CGRect labelRect = CGRectZero;
    NSInteger index = 0;
    CGFloat maxS = 0;
    for (NSUInteger i = 0; i < regions.count; i++) {
        CGRect rect = [regions[i] CGRectValue];
        CGFloat S = rect.size.width * rect.size.height;
        if (S > maxS) {
            maxS = S;
            index = i;
            labelRect = rect;
        }
    }
    CGFloat margin = 5;
    CGSize labelSize = [self.messageLabel.text boundingRectWithSize:CGSizeMake(labelRect.size.width - 2 * margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.messageLabel.font} context:nil].size;
    CGFloat messageX = 0;
    CGFloat messageY = 0;
    switch (index) {
        case 0:
            messageX = self.permitRect.origin.x - labelSize.width;
            messageY = self.permitRect.origin.y - labelSize.height;
            break;
        case 1:
            messageX = self.permitRect.origin.x;
            messageY = self.permitRect.origin.y - labelSize.height;
            break;
        case 2:
            messageX = self.permitRect.origin.x - labelSize.width;
            messageY = CGRectGetMaxY(self.permitRect);
            break;
        case 3:
            messageX = self.permitRect.origin.x;
            messageY = CGRectGetMaxY(self.permitRect);
            break;
    }
    if (messageX < _textMargin + margin) messageX = _textMargin + margin;
    self.messageLabel.frame = CGRectMake(messageX - _textMargin, messageY - _textMargin, labelSize.width + 2 * _textMargin, labelSize.height + 2 * _textMargin);
}

@end
