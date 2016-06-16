//
//  QQTransition.m
//  Transition
//
//  Created by LiuFeifei on 16/6/16.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import "QQTransition.h"
#import "QQController.h"
#import "QQSecondController.h"

@interface QQTransition ()
{
    TransitionType _transitionType;
    NSTimeInterval _duration;
//    id _transitionContext;
}
@end

@implementation QQTransition

+ (instancetype)QQMusicTransitionWithTransitionType:(TransitionType)transitionType duration:(NSTimeInterval)duration
{
    QQTransition * transition = [[QQTransition alloc] initWithTransitionType:transitionType duration:duration];
    return transition;
}
- (instancetype)initWithTransitionType:(TransitionType)transitionType duration:(NSTimeInterval)duration
{
    self = [super init];
    if (self) {
        _transitionType = transitionType;
        _duration = duration;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return _duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
//    _transitionContext = transitionContext;
    switch (_transitionType) {
        case TransitionTypeOfPresent:
            [self doPresentAnimation:transitionContext];
            break;
        case TransitionTypeOfDismiss:
            [self doDismissAnimation:transitionContext];
            break;
        default:
            break;
    }
}

- (void)doPresentAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UINavigationController * fromVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    QQController * QQVC = (QQController *)fromVC.topViewController;
    UIView * tempView = [QQVC.imageView snapshotViewAfterScreenUpdates:YES];
    QQVC.imageView.hidden = YES;
    QQSecondController * toVC = (QQSecondController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.alpha = 0;
    toVC.secondImageView.hidden = YES;
    
    UIView * containerView = [transitionContext containerView];
    tempView.frame = [containerView convertRect:QQVC.imageView.frame fromView:QQVC.containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];

    [UIView animateWithDuration:_duration animations:^{
//        CGRect frame = [containerView convertRect:toVC.secondImageView.frame fromView:toVC.view];
        CGFloat width = toVC.secondImageView.bounds.size.width;
        CGFloat height = toVC.secondImageView.bounds.size.height;
        CGRect frame = CGRectMake(containerView.center.x - width * 0.5, containerView.center.y - height * 0.5, width, height);
        tempView.frame = frame;
        NSLog(@"%f %f", tempView.center.x, tempView.center.y);
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        QQVC.imageView.hidden = NO;
        toVC.secondImageView.hidden = NO;
        [tempView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (void)doDismissAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    QQSecondController * fromVC = (QQSecondController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * tempView = [fromVC.secondImageView snapshotViewAfterScreenUpdates:YES];
    fromVC.secondImageView.hidden = YES;
    
    UINavigationController * toVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    QQController * QQVC = (QQController *)toVC.topViewController;
    QQVC.imageView.hidden = YES;
    toVC.view.alpha = 0;
    
    UIView * containerView = [transitionContext containerView];
    tempView.frame = [containerView convertRect:fromVC.secondImageView.frame fromView:fromVC.view];
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    
    [UIView animateWithDuration:_duration animations:^{
        toVC.view.alpha = 1;
        CGRect frame = [containerView convertRect:QQVC.imageView.frame fromView:QQVC.containerView];
        tempView.frame = frame;
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        QQVC.imageView.hidden = NO;
        fromVC.secondImageView.hidden = NO;
        [tempView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
