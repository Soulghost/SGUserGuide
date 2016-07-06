//
//  SGGuideNode.m
//  SGUserGuide
//
//  Created by soulghost on 5/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGGuideNode.h"

@implementation SGGuideNode

+ (instancetype)nodeWithController:(Class)controller permitViewPath:(NSString *)permitViewPath message:(NSString *)message reverse:(BOOL)reverse {
    SGGuideNode *node = [SGGuideNode new];
    node.controllerClass = controller;
    node.permitViewPath = permitViewPath;
    node.message = [message copy];
    node.reverse = reverse;
    return node;
}

+ (instancetype)endNodeWithController:(Class)controller {
    return [self nodeWithController:controller permitViewPath:nil message:nil reverse:NO];
}

@end
