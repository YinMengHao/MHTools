//
//  UIButton+MHExtension.h
//  suixingyoutarget
//
//  Created by HelloWorld on 2020/5/12.
//  Copyright © 2020 suixingyou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CallbackBlock) (UIButton * _Nullable btn);
typedef NS_ENUM(NSInteger, LXMImagePosition) {
    LXMImagePositionLeft = 0,              //图片在左，文字在右，默认
    LXMImagePositionRight = 1,             //图片在右，文字在左
    LXMImagePositionTop = 2,               //图片在上，文字在下
    LXMImagePositionBottom = 3,            //图片在下，文字在上
};
NS_ASSUME_NONNULL_BEGIN

@interface UIButton (MHExtension)
@property (nonatomic, copy) CallbackBlock callback;
+ (UIButton *)buttonWithButtonType:(UIButtonType)type backgroundColor:(UIColor * _Nullable)backgroundColor image:(UIImage * _Nullable)img title:(NSString * _Nullable)title textColor:(UIColor * _Nullable)textColor font:(UIFont * _Nullable)font cornerBlock:(void (^_Nullable)(UIButton * button))block targetCallbackBlock:(void (^_Nullable)(UIButton * button))callbackBlk;

- (void)setImagePosition:(LXMImagePosition)postion spacing:(CGFloat)spacing;
@end

NS_ASSUME_NONNULL_END
