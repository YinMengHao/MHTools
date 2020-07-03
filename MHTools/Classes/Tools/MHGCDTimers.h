//
//  MHGCDTimers.h
//  SuiXingYouShops
//
//  Created by HelloWorld on 2018/12/4.
//  Copyright © 2018 SuiXingYou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHGCDTimers : NSObject

+ (dispatch_source_t)setupTimersWithBtn:(UIButton *)retryBtn;
+ (void)configureBtnWithEnable:(BOOL)able button:(UIButton *)btn;

/**
 获取当前时间
 */
//+ (NSString *)getCurrentTime;

@end

NS_ASSUME_NONNULL_END
