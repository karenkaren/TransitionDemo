//
//  PushPopTransition.m
//  Transition
//
//  Created by LiuFeifei on 16/6/8.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import "PushPopTransition.h"

@interface PushPopTransition ()
{
    TransitionType _transitionType;
    NSTimeInterval _duration;
    id _transitionContext;
}
@end

@implementation PushPopTransition

+ (instancetype)pushPopTransitionWithTransitionType:(TransitionType)transitionType duration:(NSTimeInterval)duration
{
    PushPopTransition * transition = [[PushPopTransition alloc] initWithTransitionType:transitionType duration:duration];
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
    _transitionContext = transitionContext;
    switch (_transitionType) {
        case TransitionTypeOfPush:
            [self doPushAnimation:transitionContext];
            break;
        case TransitionTypeOfPop:
            [self doPopAnimation:transitionContext];
            break;
        default:
            break;
    }
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

- (void)doPushAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
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

- (void)doPopAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
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

@end
