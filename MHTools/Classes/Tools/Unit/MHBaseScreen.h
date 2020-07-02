//
//  MHBaseScreen.h
//  suixingyoutarget
//
//  Created by HelloWorld on 2020/5/6.
//  Copyright © 2020 suixingyou. All rights reserved.
//

#import "HQGeneralUtil.h"
#ifndef MHBaseScreen_h
#define MHBaseScreen_h



/***************************屏幕适配****************************/
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth [UIScreen mainScreen].bounds.size.width

//是否带有耳朵(>40是为了适应在开热点的情况)
#define IPHONEX (KStatusBarHeight > 40.0)
//状态栏高度
#define KStatusBarHeight [HQGeneralUtil getStatusBarHight]
#define KNavigationBarHeight (KStatusBarHeight + 44)
#endif /* MHBaseScreen_h */
