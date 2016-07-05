# SGUserGuide 

SGUserGuide is a framework for programmers to make steps to guide users, every step will restrict users to do a specific operation by adding masks to other regions. The framework can help you implement this without breaking the structure of the project based on AOP and KeyPath.

## A Simple Guide ScreenShot
You can implement a step just by creating an `SGGuideNode` object and add it to node list.
<p>
<img src="https://raw.githubusercontent.com/Soulghost/SGUserGuide/master/images/guide.png" width = "300" height = "533" alt="WiFi Page" align=center />
</p>

## How To Get Started
- [Download SGUserGuide](https://github.com/Soulghost/SGUserGuide/archive/master.zip) and try out the included iPhone example app.

## Installation
Drag the `SGUserGuide` folder to your project.

## Usage
### Import header
```objective-c
#import "SGGuideDispatcher.h"
```

### Create a node to describe a step
```objective-c
@interface SGGuideNode : NSObject

@property (nonatomic, assign) Class controllerClass;
@property (nonatomic, strong) NSString *permitViewPath;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) BOOL reverse;

+ (instancetype)nodeWithController:(Class)controller permitViewPath:(NSString *)permitViewPath message:(NSString *)message reverse:(BOOL)reverse;
+ (instancetype)endNodeWithController:(Class)controller;

@end
```

A Node has three main properties, they are:

**1.controllerClass**: The class of the controller displaying for this step.
**2.permitViewPath**: The keyPath of the view which is permit to interactive of the controller, for example, if the tableViewController has a subview topView, and the topView has a subview btn, you can pass `topView.btn` to 

