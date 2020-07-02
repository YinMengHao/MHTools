//
//  UIColor+Hex.h
//  首页视图
//
//  Created by shj on 2017/11/11.
//  Copyright © 2017年 Shj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

//以ox开头的十六进制转换成的颜色
+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)alpha;

//以#开通转换成的UIColor
+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


@end
