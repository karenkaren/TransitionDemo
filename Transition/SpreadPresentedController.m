//
//  SpreadPresentedController.m
//  Transition
//
//  Created by LiuFeifei on 16/6/8.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import "SpreadPresentedController.h"
#import "SpreadTransition.h"

@interface SpreadPresentedController ()<UIViewControllerTransitioningDelegate>

@end

@implementation SpreadPresentedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitioningDelegate = self;
}

- (IBAction)dismiss:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [SpreadTransition spreadTransitionWithTransitionType:TransitionTypeOfPresent duration:1.0];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [SpreadTransition spreadTransitionWithTransitionType:TransitionTypeOfDismiss duration:1.0];
}

@end
