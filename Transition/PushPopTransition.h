//
//  PushPopTransition.h
//  Transition
//
//  Created by LiuFeifei on 16/6/8.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TransitionType) {
    TransitionTypeOfPush,
    TransitionTypeOfPop
};

@interface PushPopTransition : NSObject<UIViewControllerAnimatedTransitioning>

+ (instancetype)pushPopTransitionWithTransitionType:(TransitionType)transitionType duration:(NSTimeInterval)duration;
- (instancetype)initWithTransitionType:(TransitionType)transitionType duration:(NSTimeInterval)duration;

@end
