//
//  UIButton+MHExtension.m
//  suixingyoutarget
//
//  Created by HelloWorld on 2020/5/12.
//  Copyright © 2020 suixingyou. All rights reserved.
//

#import "UIButton+MHExtension.h"
#import <objc/runtime.h>

@implementation UIButton (MHExtension)

- (void)setCallback:(CallbackBlock)callback {
    objc_setAssociatedObject(self, @selector(callback), callback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CallbackBlock)callback {
    return objc_getAssociatedObject(self, @selector(callback));
}

+ (UIButton *)buttonWithButtonType:(UIButtonType)type backgroundColor:(UIColor *)backgroundColor image:(UIImage *)img title:(NSString *)title textColor:(UIColor *)textColor font:(UIFont *)font cornerBlock:(void (^)(UIButton *))block targetCallbackBlock:(void (^)(UIButton *))callbackBlk {
    UIButton *btn = [UIButton buttonWithType:type];
    if (backgroundColor) {
        btn.backgroundColor = backgroundColor;
    }
    if (img) {
        [btn setImage:img forState:UIControlStateNormal];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    if (font) {
        btn.titleLabel.font = font;
    }
    if (block) {
        btn.layer.masksToBounds = YES;
        block(btn);
    }
    btn.callback = [callbackBlk copy];
    [btn addTarget:btn action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)btnClicked {
     if (self.callback) {
        self.callback([UIButton new]);
    }
}

- (void)setImagePosition:(LXMImagePosition)postion spacing:(CGFloat)spacing {


    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX =(imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
    CGFloat imageOffsetY =imageHeight / 2 + spacing / 2;//image中心移动的y距离
    
    CGFloat labelOffsetX =(imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY =labelHeight / 2 + spacing / 2;//label中心移动的y距离
    /* 防止文字发虚模糊 */
    imageOffsetX = floor(imageOffsetX);
    imageOffsetY = floor(imageOffsetY);
    labelOffsetX = floor(labelOffsetX);
    labelOffsetY = floor(labelOffsetY);
    
    
    CGFloat tempWidth =MAX(labelWidth, imageWidth);
    CGFloat changedWidth = labelWidth + imageWidth - tempWidth;
    CGFloat tempHeight =MAX(labelHeight, imageHeight);
    CGFloat changedHeight =labelHeight + imageHeight + spacing - tempHeight;
    
    switch (postion) {
        case LXMImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
            
        case LXMImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
            
        case LXMImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
            break;
            
        case LXMImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
            break;
            
        default:
            break;
    }

    
}

@end
