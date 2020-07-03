//
//  MHGCDTimers.m
//  SuiXingYouShops
//
//  Created by HelloWorld on 2018/12/4.
//  Copyright © 2018 SuiXingYou. All rights reserved.
//

#import "MHGCDTimers.h"
#define TIMECOUNT 60

@implementation MHGCDTimers

static dispatch_source_t timers;
+ (dispatch_source_t)setupTimersWithBtn:(UIButton *)retryBtn {
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
            if (second == 0) {
                [retryBtn setTitle:[NSString stringWithFormat:@"发送验证码"] forState:UIControlStateNormal];
                [self configureBtnWithEnable:YES button:retryBtn];
                second = TIMECOUNT;
                //(6)
                //                dispatch_cancel(timer);
                dispatch_suspend(timer);
                
            } else {
                [self configureBtnWithEnable:NO button:retryBtn];
                [retryBtn setTitle:[NSString stringWithFormat:@"%lds",second] forState:UIControlStateNormal];
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
//        btn.backgroundColor = [UIColor blueColor];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    } else {
        btn.userInteractionEnabled = NO;
//        btn.backgroundColor = [UIColor lightGrayColor];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}


@end
