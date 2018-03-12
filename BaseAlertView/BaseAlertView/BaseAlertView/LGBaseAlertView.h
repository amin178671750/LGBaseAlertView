//
//  LGBaseAlertView.h
//  BaseAlertView
//
//  Created by LG on 2018/2/11.
//  Copyright © 2018年 LG. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 弹出背景样式
 */
typedef NS_ENUM(NSInteger, LGBaseAlertViewStyle)
{
    LGBaseAlertViewStyleEffectExtraLight NS_ENUM_AVAILABLE_IOS(8_0) = UIBlurEffectStyleExtraLight, /**< 模糊，额外亮度，高亮风格 */
    LGBaseAlertViewStyleEffectLight NS_ENUM_AVAILABLE_IOS(8_0) = UIBlurEffectStyleLight, /**< 模糊亮风格 */
    LGBaseAlertViewStyleEffectDark NS_ENUM_AVAILABLE_IOS(8_0) = UIBlurEffectStyleDark,
    LGBaseAlertViewStyleEffectRegular NS_ENUM_AVAILABLE_IOS(10_0) = UIBlurEffectStyleRegular, // Adapts to user interface style
    LGBaseAlertViewStyleEffectProminent NS_ENUM_AVAILABLE_IOS(10_0) = UIBlurEffectStyleProminent,
    
    
    LGBaseAlertViewStyleDark = 80, /**< 正常亮暗风格 */
    LGBaseAlertViewStyleLight = 81, /**< 正常亮风格 */
};

/**
 容器视图弹出动画
 */
typedef NS_ENUM(NSInteger, LGBaseContentViewShowAnimateStyle)
{
    LGBaseContentViewShowAnimateStyleNone, /**< 无动画 */
    LGBaseContentViewShowAnimateStyleAlpha, /**< 透明度变化 */
    LGBaseContentViewShowAnimateStyleEaseIn, /**< 缓入 */
    LGBaseContentViewShowAnimateStyleEaseOut, /**< 缓出 */
    LGBaseContentViewShowAnimateStyleUpMove, /**< 从下弹出，向下隐藏 */
};

@interface LGBaseAlertView : UIView

{
    UIView *_contentView; /**< 容器视图 */
}

@property (nonatomic, assign) CGFloat retAlpha; /**< 最终背景透明度 */
@property (nonatomic, assign) LGBaseContentViewShowAnimateStyle contentAnimateStyle; /**< 容器动画样式 */
@property (nonatomic, assign) BOOL allowClickBackgroundAreaHidden; /**< 是否允许点击背景区域隐藏，默认为YES */

@property (nonatomic, strong) UIView *contentView; /**< 内容视图 */
@property (nonatomic, copy) void (^showBlock)(void); /**< 显示回调 */
@property (nonatomic, copy) void (^dismissBlock)(void); /**< 消失回调 */

/**
 初始化弹出视图
 
 @param frame 当前frame
 @param alertViewStyle 弹出视图的背景样式
 @return 弹出视图
 */
- (id)initWithFrame:(CGRect)frame alertViewStyle:(LGBaseAlertViewStyle)alertViewStyle;

/**
 弹出视图
 
 @param view 显示的父视图
 */
- (void)showInView:(UIView *)view;

/**
 弹出视图
 
 @param view 显示的父视图
 @param animated 添加动画弹出
 */
- (void)showInView:(UIView *)view animated:(BOOL)animated;

/**
 隐藏背景视图
 */
- (void)dismiss;

/**
 刷新容器视图
 */
- (void)refreshContentView;

@end
