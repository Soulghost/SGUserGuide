# SGUserGuide 

SGUserGuide is a framework for programmers to make steps to guide users, every step will restrict users to do a specific operation by adding masks to other regions. The framework can help you implement this without breaking the structure of the project based on AOP and KeyPath.

## A Simple Guide ScreenShot
You can implement a step just by creating an `SGGuideNode` object and add it to node list.
<p>
<img src="https://raw.githubusercontent.com/Soulghost/SGUserGuide/master/images/guide.png" width = "300" height = "533" alt="ScreenShot" align=center />
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

A Node has three main properties:<br/>
**1.controllerClass**: The class of the controller displaying for this step.
**2.permitViewPath**: The keyPath of the view which is permit to interactive of the controller, for example, if the tableViewController has a subview topView, and the topView has a subview btn, you can pass `topView.btn` to it.
**3.message:**: The message showing on the screen to tell uses how to do.

### Create steps by node array
Create nodes in an array and pass it to the singleton `SGGuideDispatcher`, if this step trig a switch of the view, it can be handled automatically, every node list must have a endNode, it's the end of the guide.
```objective-c
SGGuideDispatcher *dp = [SGGuideDispatcher sharedDispatcher];
dp.nodes = @[
             [SGGuideNode nodeWithController:[FirstViewController class] permitViewPath:@"addBtn" message:@"Please Click The Add Button And Choose Yes From the Alert." reverse:NO],
             [SGGuideNode nodeWithController:[FirstViewController class] permitViewPath:@"wrap.innerView" message:@"Please Click the Info Button" reverse:NO],
             [SGGuideNode nodeWithController:[SecondViewController class] permitViewPath:@"tabBarController.tabBar" message:@"Please Change To Third Page" reverse:NO],
             [SGGuideNode endNodeWithController:[ThirdViewController class]]
             ];
```
There are three steps, it describes the steps below.
<p>
<img src="https://raw.githubusercontent.com/Soulghost/SGUserGuide/master/images/guide.gif" width = "300" height = "533" alt="WiFi Page" align=center />
</p>
**Attention Please: If a step occured without a switch of view, such as click a button on the AlertView, you must handle this step yourself by calling the `next` method in the singleton `SGGuideDispatcher`.**
```objective-c
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        SGGuideDispatcher *dp = [SGGuideDispatcher sharedDispatcher];
        [dp next];
    }
}
```

### Reset guide steps
The framework will record the steps that has been made using `NSUserDefaults`, you can reset it by calling `reset` method in the singleton `SGGuideDispatcher`.
```objective-c
SGGuideDispatcher *dp = [SGGuideDispatcher sharedDispatcher];
[dp reset];
```

### Custom Settings
#### The color of the mask and the region which allow interactive.
These properties are in the singleton `SGGuideDispatcher`.

#### The attributes of the messageLabel
You can access the label in the singleton `SGGuideMaskView`.
```objective-c
UILabel *messageLabel = [SGGuideMaskView sharedMask].messageLabel;
```
