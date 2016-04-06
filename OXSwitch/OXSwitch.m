//
//  OXSwitch.m
//  OXSwitch
//
//  Created by xxoo on 16/4/6.
//  Copyright © 2016年 xxoo. All rights reserved.
//

#import "OXSwitch.h"
#import <objc/runtime.h>

#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

static char overviewKey;

static CGFloat lineWidth = 2;
static CGFloat roundViewWidth;

@interface OXSwitch ()

@property (nonatomic , assign) BOOL lastSwitch;
@property (nonatomic , assign) BOOL switchOn;
@property (nonatomic , assign) CGFloat current_X;
@property (nonatomic , strong) UIView * roundView;
@property (nonatomic , strong) CAShapeLayer * shapeLayer;

@end

@implementation OXSwitch

- (void)handleWithBlock:(UIControlEvents)touchEvent
                  blcok:(SwitchBlock)block{
    [self addTarget:self action:@selector(touchSwitch:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)touchSwitch:(OXSwitch *)oxSwtch{
    self.status = _switchOn?SwitchStatuOff:SwitchStatuOn;
    [self moveRoundViewTranslation:_switchOn?self.bounds.size.width - roundViewWidth -5:5];
    SwitchBlock block = (SwitchBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block(_switchOn);
    }
}

- (void)setStatus:(SwitchStatu)status{
    if (status == SwitchStatuOn) {
        _switchOn = YES;
    }else{
        _switchOn = NO;
    }
    [self moveRoundViewTranslation:_switchOn?self.bounds.size.width - roundViewWidth -5:5];
    [self setNeedsDisplay];
}

- (void)setCurrent_X:(CGFloat)current_X{
    if (current_X < self.bounds.size.width/2) {
        _switchOn = NO;
    }else{
        _switchOn = YES;
    }
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        小圆的尺寸
        roundViewWidth = self.bounds.size.height-10;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.roundView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    if (!_shapeLayer) {
        [self.layer insertSublayer:self.shapeLayer atIndex:0];
    }
    CGRect pathRect = CGRectMake(2, 2, self.bounds.size.width-4, self.bounds.size.height-4);
    UIBezierPath * basePath = [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:self.bounds.size.height/2];
    self.shapeLayer.path      = basePath.CGPath;
    self.shapeLayer.lineWidth = lineWidth;
    self.shapeLayer.frame     = self.bounds;

    if (!_switchOn) {
        _roundView.backgroundColor  = COLOR(68, 43, 43, 1);
        self.shapeLayer.fillColor   = COLOR(255, 255, 255, 1).CGColor;
        self.shapeLayer.strokeColor = COLOR(68, 43, 43, 1).CGColor;
    }else{
        _roundView.backgroundColor  = COLOR(255, 255, 255, 1);
        self.shapeLayer.fillColor   = COLOR(68, 43, 43, 1).CGColor;
        self.shapeLayer.strokeColor = COLOR(68, 43, 43, 1).CGColor;
    }
    self.shapeLayer.strokeStart   = 0.0f;
    self.shapeLayer.strokeEnd     = 1.0f;
}

- (CAShapeLayer *)shapeLayer{
    if (_shapeLayer == nil) {
        _shapeLayer = [CAShapeLayer layer];
    }
    return _shapeLayer;
}

- (UIView *)roundView{
    if (_roundView == nil) {
        _roundView = [[UIView alloc]init];
        CGRect rect = CGRectMake(0, 0, roundViewWidth, roundViewWidth);
        _roundView.frame = rect;
                _roundView.center = CGPointMake(roundViewWidth/2 + 5, self.bounds.size.height/2);
        _roundView.layer.masksToBounds = YES;
        _roundView.layer.cornerRadius  = roundViewWidth/2;
        _roundView.backgroundColor = COLOR(68, 43, 43, 1);
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(switchBtnDragged:)];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGeture:)];
        [_roundView addGestureRecognizer:tapGesture];
        [_roundView addGestureRecognizer:panGesture];
    }
    return _roundView;
}

- (void)tapGeture:(UITapGestureRecognizer *)tap{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)switchBtnDragged:(UIPanGestureRecognizer*)panGuester{
//    在指定坐标系中拖动
    CGFloat translation = [panGuester translationInView:panGuester.view].x;
    if (panGuester.state == UIGestureRecognizerStateChanged) {
        if (translation < 0) {//向左滑动
            CGFloat moveTrans = _current_X + translation;
            if (panGuester.view.frame.origin.x >= 5) {
                CGRect rect;
                rect = CGRectMake(moveTrans, panGuester.view.frame.origin.y, roundViewWidth, roundViewWidth);
                panGuester.view.frame = rect;
            }
        }else{//右
            if (translation >= 5 && translation <= self.bounds.size.width - roundViewWidth -5) {
                CGRect rect;
                rect = CGRectMake(translation, panGuester.view.frame.origin.y, roundViewWidth, roundViewWidth);
                panGuester.view.frame = rect;
                _current_X = panGuester.view.frame.origin.x;
            }
        }
    }
    else if (panGuester.state == UIGestureRecognizerStateEnded)
    {
        _lastSwitch = _switchOn;
        if (panGuester.view.frame.origin.x >= self.bounds.size.width/3) {
            [self moveRoundViewTranslation:self.bounds.size.width - roundViewWidth -5];
            _switchOn = YES;
        }
        else{
            [self moveRoundViewTranslation:5];
            _switchOn = NO;
        }
        
        if (_lastSwitch != _switchOn) {
            SwitchBlock block = (SwitchBlock)objc_getAssociatedObject(self, &overviewKey);
            if (block) {
                block(_switchOn);
            }
        }
    }
}

-(void)moveRoundViewTranslation:(CGFloat)translation
{
    _roundView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect;
        rect = CGRectMake(translation, _roundView.frame.origin.y, roundViewWidth, roundViewWidth);
        _roundView.frame = rect;
        self.current_X = _roundView.frame.origin.x;
        
    } completion:^(BOOL finished) {
        _roundView.userInteractionEnabled = YES;
    }];
}

@end
