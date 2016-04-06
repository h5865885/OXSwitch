//
//  OXSwitch.h
//  OXSwitch
//
//  Created by xxoo on 16/4/6.
//  Copyright © 2016年 xxoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchBlock)(BOOL status);

typedef enum : NSUInteger {
    SwitchStatuOn = 0,
    SwitchStatuOff = 1
}SwitchStatu;

@interface OXSwitch : UIControl

@property (nonatomic , assign) SwitchStatu status;

- (void)handleWithBlock:(UIControlEvents)touchEvent
                  blcok:(SwitchBlock)block;

@end
