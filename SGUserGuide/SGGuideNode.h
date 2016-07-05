//
//  SGGuideNode.h
//  SGUserGuide
//
//  Created by soulghost on 5/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGGuideNode : NSObject

@property (nonatomic, assign) Class controllerClass;
@property (nonatomic, strong) NSString *permitViewPath;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) BOOL reverse;

+ (instancetype)nodeWithController:(Class)controller permitViewPath:(NSString *)permitViewPath message:(NSString *)message reverse:(BOOL)reverse;
+ (instancetype)endNodeWithController:(Class)controller;

@end
