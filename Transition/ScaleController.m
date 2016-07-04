//
//  ScaleController.m
//  Transition
//
//  Created by LiuFeifei on 16/7/1.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import "ScaleController.h"
#import "TransitionAnimator.h"

@interface ScaleController ()<UINavigationControllerDelegate>

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition * interaction;

@end

@implementation ScaleController

- (IBAction)popClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:pan];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.interaction = [[UIPercentDrivenInteractiveTransition alloc] init];
            if (self.navigationController.viewControllers.count > 2) {
                [self.navigationController popViewControllerAnimated:YES];
            } else if (self.navigationController.viewControllers.count > 1){
                [self performSegueWithIdentifier:@"kPushSegue" sender:nil];
            }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint transition = [pan translationInView:self.view];
            CGFloat completionProgress = transition.x / CGRectGetWidth(self.view.bounds);
            [self.interaction updateInteractiveTransition:completionProgress];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            if ([pan velocityInView:self.navigationController.view].x > 0) {
                NSLog(@"----=====%f",[pan velocityInView:self.navigationController.view].x);
                [self.interaction finishInteractiveTransition];
            } else {
                [self.interaction cancelInteractiveTransition];
            }
            self.interaction = nil;
            break;
        default:
            break;
    }
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop && self.navigationController.viewControllers.count <= 1) {
        return nil;
    }
    return (id)[[TransitionAnimator alloc] init];
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return self.interaction;
}

@end
