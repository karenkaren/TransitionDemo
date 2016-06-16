//
//  SpreadTransition.m
//  Transition
//
//  Created by LiuFeifei on 16/6/8.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import "SpreadTransition.h"
#import "SpreadController.h"

@interface SpreadTransition ()

{
    TransitionType _transitionType;
    NSTimeInterval _duration;
    id _transitionContext;
}

@end

@implementation SpreadTransition

+ (instancetype)spreadTransitionWithTransitionType:(TransitionType)transitionType duration:(NSTimeInterval)duration
{
    SpreadTransition * transition = [[SpreadTransition alloc] initWithTransitionType:transitionType duration:duration];
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
    SpreadController * temp = (SpreadController *)fromVC.topViewController;
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView * container = [transitionContext containerView];
    [container addSubview:toVC.view];
    
    CGRect buttonFrame = [temp getButtonFrame];
    UIBezierPath * startPath = [UIBezierPath bezierPathWithOvalInRect:buttonFrame];
    CGFloat x = MAX(buttonFrame.origin.x, container.bounds.size.width - buttonFrame.origin.x);
    CGFloat y = MAX(buttonFrame.origin.y, container.bounds.size.height - buttonFrame.origin.y);
    CGFloat endRadius = sqrt(pow(x, 2) + pow(y, 2));
    UIBezierPath * endPath = [UIBezierPath bezierPathWithArcCenter:container.center radius:endRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = endPath.CGPath;
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.duration = _duration;
    animation.fromValue = (__bridge id _Nullable)(startPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    [maskLayer addAnimation:animation forKey:@"present"];
}

- (void)doDismissAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController * toVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    SpreadController * spread = (SpreadController *)toVC.topViewController;
    
    UIView * container = [transitionContext containerView];
    UIView * fromTemp = [fromVC.view snapshotViewAfterScreenUpdates:YES];
    UIView * toTemp = [toVC.view snapshotViewAfterScreenUpdates:YES];
    [container addSubview:toTemp];
    [container addSubview:fromTemp];
    
    CGRect buttonFrame = [spread getButtonFrame];
    CGFloat startRadius = sqrt(pow(container.bounds.size.width, 2) + pow(container.bounds.size.height, 2)) / 2;
    UIBezierPath * startPath = [UIBezierPath bezierPathWithArcCenter:container.center radius:startRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    UIBezierPath * endPath = [UIBezierPath bezierPathWithOvalInRect:buttonFrame];
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = endPath.CGPath;
    fromTemp.layer.mask = maskLayer;
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.duration = _duration;
    animation.fromValue = (__bridge id _Nullable)(startPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    [maskLayer addAnimation:animation forKey:@"dismiss"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [_transitionContext completeTransition:YES];
    }
}

@end
