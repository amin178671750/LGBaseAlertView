//
//  LGBaseTextAlertView.m
//  BaseAlertView
//
//  Created by LG on 2018/2/11.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "LGBaseTextAlertView.h"

#define floatContentLeftSpacing 20
#define floatContentMaxTopSpacing 50
#define floatTitleLeftSpacing 25
#define floatTitleTopSpacing 20
#define floatTitleSpacing 5
#define floatCloseButtonEdgeSpacing 4.0f
#define floatCloseButtonWidth (20 + floatCloseButtonEdgeSpacing*2)
#define floatCloseButtonSpacing 8

@interface LGBaseTextAlertView ()

@property (nonatomic, strong) UIScrollView *textBackgroundView; /**< 文本背景视图 */
@property (nonatomic, strong) UILabel *textLabel; /**< 显示文本 */
@property (nonatomic, strong) UIButton *closeButton; /**< 关闭按钮 */

@end

@implementation LGBaseTextAlertView

#pragma mark - Super

- (id)initWithFrame:(CGRect)frame alertViewStyle:(LGBaseAlertViewStyle)alertViewStyle
{
    self = [super initWithFrame:frame alertViewStyle:alertViewStyle];
    if (self) {
    }
    return self;
}

#pragma mark - Public

#pragma mark - Data

#pragma mark -

#pragma mark - Event

//关闭按钮点击方法
- (void)closeButtonPress:(UIButton *)button
{
    [self dismiss];
}

//触摸容器视图触摸事件
- (void)contentViewTapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}

#pragma mark - Private

- (void)refreshContentFrameWithLabelSize:(CGSize)labelSize
{
    CGSize textSize = labelSize;
    textSize.height += floatTitleSpacing;
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    //最大高度
    CGFloat maxHeight = height - 2*floatContentMaxTopSpacing;
    //文本总高度
    CGFloat titleTotalHeight = textSize.height + 2*floatTitleTopSpacing;
    //按钮区域总高度
    CGFloat buttonAllHeight = floatCloseButtonSpacing*2 + floatCloseButtonWidth;
    
    CGFloat contentWidth = width - 2*floatContentLeftSpacing;
    CGFloat contentHeight = titleTotalHeight + buttonAllHeight;
    contentHeight = MIN(maxHeight, contentHeight);
    
    CGFloat contentY = (height - contentHeight)/2.0f;
    CGRect contentFrame = CGRectMake(floatContentLeftSpacing, contentY, contentWidth, contentHeight);
    _contentView.frame = contentFrame;
    
    CGRect titleBackgroundFrame = CGRectMake(0, 0, contentWidth, contentHeight - buttonAllHeight);
    _textBackgroundView.contentSize = CGSizeMake(contentWidth, titleTotalHeight);
    _textBackgroundView.frame = titleBackgroundFrame;
    
    CGRect titleFrame = _textLabel.frame;
    titleFrame.size.height = textSize.height;
    _textLabel.frame = titleFrame;
    
    CGRect buttonFrame = _closeButton.frame;
    buttonFrame.origin.x = (contentWidth - buttonFrame.size.width)/2.0f;
    buttonFrame.origin.y = contentHeight - buttonFrame.size.height - floatCloseButtonSpacing;
    _closeButton.frame = buttonFrame;
    
    [self refreshContentView];
}

#pragma mark - Getters and setters

- (void)setText:(NSString *)text
{
    _text = text;
    
    //赋值可以计算出占用的尺寸
    _textLabel.text = _text;
    [_textLabel sizeToFit];
    [self refreshContentFrameWithLabelSize:_textLabel.frame.size];
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    _attributedString = attributedString;
    
    //赋值可以计算出占用的尺寸
    _textLabel.attributedText = attributedString;
    [_textLabel sizeToFit];
    [self refreshContentFrameWithLabelSize:_textLabel.frame.size];
}

- (UIView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        
        [_contentView addSubview:self.textBackgroundView];
        [_contentView addSubview:self.closeButton];
        
        //添加触摸事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapGestureRecognizer:)];
        [_contentView addGestureRecognizer:tap];
    }
    return _contentView;
}

- (UIScrollView *)textBackgroundView
{
    if (_textBackgroundView == nil)
    {
        _textBackgroundView = [[UIScrollView alloc] init];
        _textBackgroundView.backgroundColor = [UIColor whiteColor];
        _textBackgroundView.showsVerticalScrollIndicator = NO;
        _textBackgroundView.showsHorizontalScrollIndicator = NO;
        
        //添加圆角及边框
        _textBackgroundView.layer.cornerRadius = 15;
        _textBackgroundView.layer.masksToBounds = YES;
        
        [_textBackgroundView addSubview:self.textLabel];
    }
    return _textBackgroundView;
}

- (UILabel *)textLabel
{
    if (_textLabel == nil)
    {
        _textLabel = [[UILabel alloc]init];
        _textLabel.frame = CGRectMake(floatTitleLeftSpacing, floatTitleTopSpacing, CGRectGetWidth(self.frame) - 2*(floatContentLeftSpacing + floatTitleLeftSpacing), 1);
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (UIButton *)closeButton
{
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] init];
        _closeButton.frame = CGRectMake(0, 0, floatCloseButtonWidth, floatCloseButtonWidth);
        _closeButton.backgroundColor = [UIColor whiteColor];
        [_closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImageEdgeInsets:UIEdgeInsetsMake(floatCloseButtonEdgeSpacing, floatCloseButtonEdgeSpacing, floatCloseButtonEdgeSpacing, floatCloseButtonEdgeSpacing)];
        
        //添加圆角及边框
        _closeButton.layer.cornerRadius = floatCloseButtonWidth/2.0f;
        _closeButton.layer.borderWidth = 0.5f;
        _closeButton.layer.masksToBounds = YES;
        _closeButton.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    return _closeButton;
}

@end
