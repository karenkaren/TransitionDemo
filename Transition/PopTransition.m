//
//  PopTransition.m
//  Transition
//
//  Created by LiuFeifei on 16/6/7.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import "PopTransition.h"

@interface PopTransition ()

@property (nonatomic, strong) id transitionContext;

@end

@implementation PopTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    _transitionContext = transitionContext;
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView * contrainer = [transitionContext containerView];
    [contrainer addSubview:toVC.view];
    [contrainer addSubview:fromVC.view];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 500.0;
    fromVC.view.layer.transform = transform;
    
    fromVC.view.layer.anchorPoint = CGPointMake(1.0, 0.5);
    fromVC.view.layer.position = CGPointMake(toVC.view.bounds.size.width, CGRectGetMidY(toVC.view.frame));
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.duration = [self transitionDuration:transitionContext];
    animation.fromValue = @0;
    animation.toValue = @(M_PI_2);
    animation.delegate = self;
    [fromVC.view.layer addAnimation:animation forKey:@"rotationY"];
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
