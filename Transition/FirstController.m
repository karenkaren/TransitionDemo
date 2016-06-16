//
//  FirstController.m
//  Transition
//
//  Created by LiuFeifei on 16/6/7.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import "FirstController.h"
#import "PushPopTransition.h"

@interface FirstController ()<UINavigationControllerDelegate>

{
    UIScreenEdgePanGestureRecognizer * _pan;
    UIPercentDrivenInteractiveTransition * _interactive;
}

@end

@implementation FirstController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _pan.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:_pan];
}

- (void)handlePanGesture:(UIScreenEdgePanGestureRecognizer *)sender
{
    CGFloat progress = -1 * [sender translationInView:self.view].x / CGRectGetWidth(self.view.frame);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            _interactive = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self performSegueWithIdentifier:@"kPushToSecond" sender:nil];
            break;
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

- (IBAction)pushToSecond:(UIButton *)sender {
    [self performSegueWithIdentifier:@"kPushToSecond" sender:nil];
}


#pragma mark - UINavigationControllerDelegate
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
    if (operation == UINavigationControllerOperationPush) {
        return [PushPopTransition pushPopTransitionWithTransitionType:TransitionTypeOfPush duration:1.0];
    }
    return nil;
}


@end
