//
//  QQTransition.h
//  Transition
//
//  Created by LiuFeifei on 16/6/16.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TransitionType) {
    TransitionTypeOfPresent,
    TransitionTypeOfDismiss
};

@interface QQTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)QQMusicTransitionWithTransitionType:(TransitionType)transitionType duration:(NSTimeInterval)duration;
- (instancetype)initWithTransitionType:(TransitionType)transitionType duration:(NSTimeInterval)duration;

@end
