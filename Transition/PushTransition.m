//
//  PushTransition.m
//  Transition
//
//  Created by LiuFeifei on 16/6/7.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import "PushTransition.h"

@interface PushTransition ()

@property (nonatomic, strong) id transitionContext;

@end

@implementation PushTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    _transitionContext = transitionContext;
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView * container = [transitionContext containerView];
    [container addSubview:fromVC.view];
    [container addSubview:toVC.view];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 500.0;
    toVC.view.layer.transform = transform;
    
    toVC.view.layer.anchorPoint = CGPointMake(1.0, 0.5);
    toVC.view.layer.position = CGPointMake(fromVC.view.bounds.size.width, CGRectGetMidY(fromVC.view.frame));
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.duration = [self transitionDuration:transitionContext];
    animation.fromValue = @(M_PI_2);
    animation.toValue = @0;
    animation.delegate = self;
    [toVC.view.layer addAnimation:animation forKey:@"rotationY"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        
        [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
        if ([_transitionContext transitionWasCancelled]) {
            [_transitionContext cancelInteractiveTransition];
        } else {
            [_transitionContext finishInteractiveTransition];
        }
    }
}

@end
