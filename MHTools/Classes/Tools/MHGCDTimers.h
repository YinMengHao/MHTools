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

+ (dispatch_source_t)setupTimersWithBtn:(UIButton *)retryBtn title:(NSString *)title;
+ (void)configureBtnWithEnable:(BOOL)able button:(UIButton *)btn;
+ (dispatch_source_t)setupTimersWithBtn:(UIButton *)retryBtn title:(NSString *)title currentSecond:(void (^) (NSUInteger second))secondBlock;
/**
 获取当前时间
 */
//+ (NSString *)getCurrentTime;

@end

NS_ASSUME_NONNULL_END
