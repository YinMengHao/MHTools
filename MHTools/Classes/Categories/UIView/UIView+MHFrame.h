//
//  UIView+MHFrame.h
//  SuiXingYouShops
//
//  Created by HelloWorld on 2019/6/17.
//  Copyright © 2019 SuiXingYou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MHFrame)
@property (nonatomic, assign) CGFloat mh_x;//frame.origin.x
@property (nonatomic, assign) CGFloat mh_y;//frame.origin.y
@property (nonatomic, assign) CGFloat mh_right;//frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat mh_bottom;//frame.origin.y + frame.size.height
@property (nonatomic, assign) CGFloat mh_width;//frame.size.width
@property (nonatomic, assign) CGFloat mh_height;//frame.size.height.
@property (nonatomic, assign) CGFloat mh_centerX;//center.x
@property (nonatomic, assign) CGFloat mh_centerY;//center.y
@property (nonatomic, assign) CGPoint mh_origin;//frame.origin
@property (nonatomic, assign) CGSize mh_size;//frame.size
@end

NS_ASSUME_NONNULL_END
