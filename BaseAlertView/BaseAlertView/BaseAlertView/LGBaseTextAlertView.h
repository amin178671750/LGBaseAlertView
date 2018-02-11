//
//  LGBaseTextAlertView.h
//  BaseAlertView
//
//  Created by LG on 2018/2/11.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "LGBaseAlertView.h"

@interface LGBaseTextAlertView : LGBaseAlertView

@property (nonatomic, copy) NSString *text; /**< 显示文本 */
@property (nonatomic, strong) NSAttributedString *attributedString; /**< 显示富文本 */

@end
