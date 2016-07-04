//
//  TransitionAnimator.m
//  Transition
//
//  Created by LiuFeifei on 16/7/4.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import "TransitionAnimator.h"
#import "ScaleController.h"

@interface TransitionAnimator ()<UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) id transitionContext;

@end

@implementation TransitionAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    UIView * containerView = [transitionContext containerView];
    
    ScaleController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ScaleController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIButton * button = fromVC.popBtn;
    [containerView addSubview:toVC.view];
    
    UIBezierPath * circleMaskPathInitial = [UIBezierPath bezierPathWithOvalInRect:button.frame];
    CGPoint extyremePoint = CGPointMake(button.center.x, button.center.y - CGRectGetHeight(toVC.view.bounds));
    CGFloat radius = sqrt(extyremePoint.x * extyremePoint.x + extyremePoint.y * extyremePoint.y);
    UIBezierPath * circleMaskPathFinal = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = circleMaskPathFinal.CGPath;
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation * maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id _Nullable)(circleMaskPathInitial.CGPath);
    maskLayerAnimation.toValue = (__bridge id _Nullable)(circleMaskPathFinal.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
        [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    }
}

@end
