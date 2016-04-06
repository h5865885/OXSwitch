//
//  ViewController.m
//  OXSwitch
//
//  Created by xxoo on 16/4/6.
//  Copyright © 2016年 xxoo. All rights reserved.
//

#import "ViewController.h"
#import "OXSwitch.h"

@interface ViewController ()

@property (nonatomic , strong) OXSwitch * oxSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.oxSwitch];
    self.oxSwitch.status = SwitchStatuOff;
    [self.oxSwitch handleWithBlock:UIControlEventTouchUpInside blcok:^(BOOL status) {
        NSLog(@"status = %d",status);
    }];
}

- (OXSwitch *)oxSwitch{
    if (_oxSwitch == nil) {
        _oxSwitch = [[OXSwitch alloc]initWithFrame:CGRectMake(50, 50, 40, 25)];
    }
    return _oxSwitch;
}

@end
