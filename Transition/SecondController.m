//
//  SecondController.m
//  Transition
//
//  Created by LiuFeifei on 16/6/7.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import "SecondController.h"
#import "PushPopTransition.h"

@interface SecondController ()<UINavigationControllerDelegate>

{
    UIScreenEdgePanGestureRecognizer * _pan;
    UIPercentDrivenInteractiveTransition * _interactive;
}

@end

@implementation SecondController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _pan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:_pan];
}

- (void)handlePanGesture:(UIScreenEdgePanGestureRecognizer *)sender
{
    CGFloat progress = [sender translationInView:self.view].x / CGRectGetWidth(self.view.frame);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            _interactive = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self.navigationController popViewControllerAnimated:YES];
        case UIGestureRecognizerStateChanged:
            [_interactive updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            if (progress >= 0.5) {
                [_interactive finishInteractiveTransition];
            } else {
                [_interactive cancelInteractiveTransition];
            }
            _interactive = nil;
            break;
        default:
            break;
    }
}


- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return _interactive;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return [PushPopTransition pushPopTransitionWithTransitionType:TransitionTypeOfPop duration:1.0];
    }
    return nil;
}

@end
