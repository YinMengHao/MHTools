//
//  UIView+MHFrame.m
//  SuiXingYouShops
//
//  Created by HelloWorld on 2019/6/17.
//  Copyright © 2019 SuiXingYou. All rights reserved.
//

#import "UIView+MHFrame.h"

@implementation UIView (MHFrame)

- (void)setMh_x:(CGFloat)mh_x {
    CGRect frame = self.frame;
    frame.origin.x = mh_x;
    self.frame = frame;
}
- (CGFloat)mh_x {
    return self.frame.origin.x;
}

- (void)setMh_y:(CGFloat)mh_y {
    CGRect frame = self.frame;
    frame.origin.y = mh_y;
    self.frame = frame;
}
- (CGFloat)mh_y {
    return self.frame.origin.y;
}

- (void)setMh_right:(CGFloat)mh_right {
    CGRect frame = self.frame;
    frame.origin.x = mh_right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)mh_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setMh_bottom:(CGFloat)mh_bottom {
    CGRect frame = self.frame;
    frame.origin.y = mh_bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat)mh_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMh_width:(CGFloat)mh_width {
    CGRect frame = self.frame;
    frame.size.width = mh_width;
    self.frame = frame;
}
- (CGFloat)mh_width {
    return self.frame.size.width;
}

- (void)setMh_height:(CGFloat)mh_height {
    CGRect frame = self.frame;
    frame.size.height = mh_height;
    self.frame = frame;
}
- (CGFloat)mh_height {
    return self.frame.size.height;
}

- (void)setMh_centerX:(CGFloat)mh_centerX {
    self.center = CGPointMake(mh_centerX, self.center.y);
}
- (CGFloat)mh_centerX {
    return self.center.x;
}

- (void)setMh_centerY:(CGFloat)mh_centerY {
    self.center = CGPointMake(self.center.x, mh_centerY);
}
- (CGFloat)mh_centerY {
    return self.center.y;
}

- (void)setMh_origin:(CGPoint)mh_origin {
    CGRect frame = self.frame;
    frame.origin = mh_origin;
    self.frame = frame;
}
- (CGPoint)mh_origin {
    return self.frame.origin;
}

- (void)setMh_size:(CGSize)mh_size {
    CGRect frame = self.frame;
    frame.size = mh_size;
    self.frame = frame;
}
- (CGSize)mh_size {
    return self.frame.size;
}

@end
