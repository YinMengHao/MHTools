//
//  UIImage+Extention.h
//  suixingyoutarget
//
//  Created by HelloWorld on 2020/5/6.
//  Copyright © 2020 suixingyou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extention)
- (UIImage *)circleImage;
- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
- (UIImage *)imageChangeColor:(UIColor *)color;//修改图片颜色
// UIColor 转UIImage
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
