//
//  LGBaseAlertView.m
//  BaseAlertView
//
//  Created by LG on 2018/2/11.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "LGBaseAlertView.h"

#define floatDefaultInitAlpha 0.0f
#define floatDefaultRetAlpha 0.8f
#define floatDefaultEffectRetAlpha 1.0f //模糊背景视图的透明度为1时效果最显著
#define floatAlertAnimationDuration 0.3f

@interface LGBaseAlertView ()<
CAAnimationDelegate
>
{
    BOOL _lastAnimated; /**< 最后一次动画状态 */
    BOOL _animatedIsShow; /**< 执行的动画是否是显示 */
    CGRect _contentViewFrame; /**< 容器视图的位置 */
    CGFloat _contentViewAlpha; /**< 容器视图的透明度 */
}

@property (nonatomic, strong) UIView *backgroundView; /**< 背景视图 */
@property (nonatomic, strong) UIVisualEffectView *backgroundEffectView; /**< 模糊背景视图 */

@property (nonatomic, assign) LGBaseAlertViewStyle alertViewStyle; /**< 弹出背景样式 */

@end

@implementation LGBaseAlertView

@synthesize retAlpha = _retAlpha;
@synthesize contentAnimateStyle = _contentAnimateStyle;
@synthesize contentView = _contentView;

#pragma mark - Super

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame alertViewStyle:LGBaseAlertViewStyleDark];
}

- (instancetype)initWithFrame:(CGRect)frame alertViewStyle:(LGBaseAlertViewStyle)alertViewStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        _alertViewStyle = alertViewStyle;
        
        self.userInteractionEnabled = YES;
        
        //设置默认值
        _lastAnimated = YES;
        _retAlpha = [self isVisualEffect]?floatDefaultEffectRetAlpha:floatDefaultRetAlpha;
        _contentAnimateStyle = LGBaseContentViewShowAnimateStyleEaseIn;
        
        UIView *backView = [self isVisualEffect]?self.backgroundEffectView:self.backgroundView;
        [self addSubview:backView];
        
        //添加容器视图
        [self addSubview:self.contentView];
        [self refreshContentView];
    }
    return self;
}

#pragma mark - Public

- (void)showInView:(UIView *)view
{
    [self showInView:view animated:YES];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    //存储动画状态
    _lastAnimated = animated;
    
    view = view?view:[[UIApplication sharedApplication] keyWindow];
    [view addSubview:self];
    
    [self backgroundViewShowOfDismiss:YES];
    [self contentViewAnimationWithShow:YES];
}

- (void)dismiss
{
    [self backgroundViewShowOfDismiss:NO];
    [self contentViewAnimationWithShow:NO];
}

- (void)refreshContentView
{
    //保存容器视图的位置
    _contentViewFrame = _contentView.frame;
    //保存容器视图的透明度
    _contentViewAlpha = _contentView.alpha;
}

#pragma mark - Data

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
    //更换透明度
    _contentView.alpha = _animatedIsShow?0.0f:_contentViewAlpha;
    [UIView animateWithDuration:anim.duration animations:^{
        _contentView.alpha = _animatedIsShow?_contentViewAlpha:0.0f;
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_contentView.layer removeAllAnimations];
    [self allAnimationCompletedWithShow:_animatedIsShow];
}

#pragma mark - Event

//背景视图触摸事件
- (void)backgroundViewTapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}

#pragma mark - Private

/**
 通过弹出背景样式返回背景视图的颜色
 */
- (UIColor *)backgroundColorWithAlertViewStyle:(LGBaseAlertViewStyle)alertViewStyle
{
    UIColor *retColor = [UIColor blackColor];
    if (alertViewStyle > LGBaseAlertViewStyleDark) {
        retColor = [UIColor whiteColor];
    }
    return retColor;
}

/**
 是否是模糊视图
 */
- (BOOL)isVisualEffect
{
    return !(_alertViewStyle >= LGBaseAlertViewStyleDark);
}

/**
 背景视图显示或者隐藏
 */
- (void)backgroundViewShowOfDismiss:(BOOL)show
{
    UIView *backView = [self isVisualEffect]?self.backgroundEffectView:self.backgroundView;
    
    void(^retBlock)(void) = ^(void){
        backView.alpha = show?_retAlpha:floatDefaultInitAlpha;
    };
    
    if (_lastAnimated) {
        [UIView animateWithDuration:floatAlertAnimationDuration
                         animations:^{
                             backView.alpha = show?_retAlpha:floatDefaultInitAlpha;
                         }
                         completion:^(BOOL finished) {
                             retBlock();
                         }];
    }
    else
    {
        retBlock();
    }
}

- (void)contentViewAnimationWithShow:(BOOL)show
{
    //实现不同的动画加载
    switch (_contentAnimateStyle) {
        case LGBaseContentViewShowAnimateStyleEaseIn:
        {
            [self easeInAnimationWithShow:show];
        }
            break;
        case LGBaseContentViewShowAnimateStyleEaseOut:
        {
            [self easeOutAnimationWithShow:show];
        }
            break;
        case LGBaseContentViewShowAnimateStyleAlpha:
        {
            [self changeAlphaAnimationWithShow:show];
        }
            break;
        case LGBaseContentViewShowAnimateStyleUpMove:
        {
            [self moveAnimationWithShow:show];
        }
            break;
        case LGBaseContentViewShowAnimateStyleNone:
        default:
        {
            if (_lastAnimated) {
                //GCD延时,毫秒单位
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(floatAlertAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self allAnimationCompletedWithShow:show];
                });
            }
            else
            {
                [self allAnimationCompletedWithShow:show];
            }
        }
            break;
    }
}

//缓入缓出动画
- (void)easeInAnimationWithShow:(BOOL)show
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = floatAlertAnimationDuration;
    animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    _animatedIsShow = show;
    if (show) {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.7, 1.7, 0.1)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 0.3)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 0.5)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 0.7)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    }
    else
    {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 0.7)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 0.3)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0001, 0.0001, 0.0001)]];
        
    }
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    if (_animatedIsShow) {
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    }
    
    [_contentView.layer addAnimation:animation forKey:nil];
}

//缓出缓入动画
- (void)easeOutAnimationWithShow:(BOOL)show
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = floatAlertAnimationDuration;
    animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    _animatedIsShow = show;
    if (show) {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0001, 0.0001, 0.0001)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 0.3)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 0.7)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    }
    else
    {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 0.7)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 0.5)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 0.3)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.7, 1.7, 0.1)]];
        
    }
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    if (_animatedIsShow) {
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    }
    
    [_contentView.layer addAnimation:animation forKey:nil];
}

//改变透明度动画
- (void)changeAlphaAnimationWithShow:(BOOL)show
{
    _contentView.alpha = show?0.0f:_contentViewAlpha;
    
    [UIView animateWithDuration:floatAlertAnimationDuration
                     animations:^{
                         _contentView.alpha = show?_contentViewAlpha:0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self allAnimationCompletedWithShow:show];
                     }];
}

- (void)moveAnimationWithShow:(BOOL)show
{
    CGRect hiddenContentFrame = _contentViewFrame;
    hiddenContentFrame.origin.y = CGRectGetMaxY(self.frame);
    
    //首先设置成动画之前的值
    _contentView.frame = show?hiddenContentFrame:_contentViewFrame;
    
    [UIView animateWithDuration:floatAlertAnimationDuration
                     animations:^{
                         _contentView.frame = show?_contentViewFrame:hiddenContentFrame;
                     }
                     completion:^(BOOL finished) {
                         [self allAnimationCompletedWithShow:show];
                     }];
}

//所有动画完成
- (void)allAnimationCompletedWithShow:(BOOL)show
{
    if (!show) {
        //移除视图
        [self removeFromSuperview];
    }
}

#pragma mark - Getters and setters

- (void)setRetAlpha:(CGFloat)retAlpha
{
    UIView *backView = [self isVisualEffect]?self.backgroundEffectView:self.backgroundView;
    if (backView.alpha == _retAlpha) {
        //判断是否已经加载完成
        backView.alpha = retAlpha;
    }
    
    _retAlpha = retAlpha;
}

- (UIView *)backgroundView
{
    if (_backgroundView == nil)
    {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [self backgroundColorWithAlertViewStyle:_alertViewStyle];
        _backgroundView.alpha = floatDefaultInitAlpha;
        
        //添加触摸事件
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapGestureRecognizer:)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

- (UIVisualEffectView *)backgroundEffectView
{
    if (_backgroundEffectView == nil)
    {
        UIBlurEffectStyle effectStyle = (UIBlurEffectStyle)_alertViewStyle;
        UIBlurEffect *backgroundEffect = [UIBlurEffect effectWithStyle:effectStyle];
        
        _backgroundEffectView = [[UIVisualEffectView alloc] initWithEffect:backgroundEffect];
        _backgroundEffectView.frame = self.bounds;
        _backgroundEffectView.alpha = floatDefaultInitAlpha;
        
        //添加触摸事件
        _backgroundEffectView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapGestureRecognizer:)];
        [_backgroundEffectView addGestureRecognizer:tap];
    }
    return _backgroundEffectView;
}

- (UIView *)contentView
{
    if (_contentView == nil)
    {
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        CGFloat contentWidth = width*0.8;
        CGFloat contentHeight = height*0.5;
        CGFloat x = (width - contentWidth)/2.0f;
        CGFloat y = (height - contentHeight)/2.0f;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(x, y, contentWidth, contentHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

@end
