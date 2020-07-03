//
//  MHGCDTimers.m
//  SuiXingYouShops
//
//  Created by HelloWorld on 2018/12/4.
//  Copyright © 2018 SuiXingYou. All rights reserved.
//

#import "MHGCDTimers.h"
#import "MHBaseConfigure.h"
#define TIMECOUNT 10

@implementation MHGCDTimers

static dispatch_source_t timers;
+ (dispatch_source_t)setupTimersWithBtn:(UIButton *)retryBtn title:(nonnull NSString *)title {
    return [self configureTimerWithButton:retryBtn title:title callback:nil];
}
+ (dispatch_source_t)setupTimersWithBtn:(UIButton *)retryBtn title:(nonnull NSString *)title currentSecond:(void (^) (NSUInteger second))secondBlock {
    return [self configureTimerWithButton:retryBtn title:title callback:secondBlock];
}
+ (dispatch_source_t)configureTimerWithButton:(UIButton *)retryBtn title:(nonnull NSString *)title callback:(void (^) (NSUInteger second))secondBlock {
    __block NSInteger second = TIMECOUNT;
    //(1)
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //(2)
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    timers = timer;
    //(3)
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //(4)
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (secondBlock) {
                secondBlock(second);
            }
            if (second == 0) {
                [retryBtn setTitle:title forState:UIControlStateNormal];
                [self configureBtnWithEnable:YES button:retryBtn];
                second = TIMECOUNT;
                //(6)
                //                dispatch_cancel(timer);
                dispatch_suspend(timer);
                
            } else {
                [self configureBtnWithEnable:NO button:retryBtn];
                [retryBtn setTitle:[NSString stringWithFormat:@"%@(%ld)", title, second] forState:UIControlStateNormal];
                second--;
            }
        });
    });
    //(5)
    dispatch_resume(timers);
    return timers;
}

+ (void)configureBtnWithEnable:(BOOL)able button:(UIButton *)btn {
    if (able) {
        btn.userInteractionEnabled = YES;
        [btn setTitleColor:UIMainColor forState:UIControlStateNormal];
    } else {
        btn.userInteractionEnabled = NO;
        [btn setTitleColor:UIColorNine forState:UIControlStateNormal];
    }
}


@end
