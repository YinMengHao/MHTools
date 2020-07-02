//
//  UIView+MHExtension.m
//  SuiXingYouShops
//
//  Created by HelloWorld on 2019/2/13.
//  Copyright © 2019 SuiXingYou. All rights reserved.
//

#import "UIView+MHExtension.h"

@implementation UIView (MHExtension)

- (UIViewController *)getViewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)removeAllSubViews {
    NSArray *subViewAry = self.subviews;
    [subViewAry enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isKindOfClass:[UIStackView class]]) {
            [(UIStackView*)self removeArrangedSubview:obj];
        }
        [obj removeFromSuperview];
    }];
}

- (UIView *)getSuperview:(Class)cls {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:cls]) {
            return (UIView *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (UIViewController *)getSuperController:(Class)cls {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:cls]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
//为指定view切指定位置的圆角
+ (void)cornerWithView:(UIView *)view roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}
@end
