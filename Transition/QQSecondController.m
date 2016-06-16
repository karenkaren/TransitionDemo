//
//  QQSecondController.m
//  Transition
//
//  Created by LiuFeifei on 16/6/16.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import "QQSecondController.h"
#import "QQTransition.h"

@interface QQSecondController ()<UIViewControllerTransitioningDelegate>

@end

@implementation QQSecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.transitioningDelegate = self;
}

- (IBAction)dismiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [QQTransition QQMusicTransitionWithTransitionType:TransitionTypeOfPresent duration:0.5];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [QQTransition QQMusicTransitionWithTransitionType:TransitionTypeOfDismiss duration:0.5];
}

@end
