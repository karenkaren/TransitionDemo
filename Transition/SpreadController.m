//
//  SpreadController.m
//  Transition
//
//  Created by LiuFeifei on 16/6/8.
//  Copyright © 2016年 LiuJie. All rights reserved.
//

#import "SpreadController.h"

@interface SpreadController ()

@property (nonatomic, weak) IBOutlet UIButton * button;

@end

@implementation SpreadController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (CGRect)getButtonFrame
{
    return _button.frame;
}

@end
