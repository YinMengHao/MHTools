//
//  UIView+MHExtension.h
//  SuiXingYouShops
//
//  Created by HelloWorld on 2019/2/13.
//  Copyright © 2019 SuiXingYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHBaseConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MHExtension)
- (UIViewController *)getViewController;

//从stackView中移除所有子视图
- (void)removeAllSubViews;

//获取某个view的父view为指定的类
- (UIView *)getSuperview:(Class)cls;

- (UIViewController *)getSuperController:(Class)cls;

//为指定view切指定位置的圆角
+ (void)cornerWithView:(UIView *)view roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
@end

NS_ASSUME_NONNULL_END
