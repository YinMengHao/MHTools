//
//  UIViewController+Swizzling.m
//  类别
//
//  Created by fly on 16/10/29.
//  Copyright © 2016年 石峰. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (Swizzling)

+ (void)load {
    
    //我们只有在开发的时候才需要查看哪个viewController将出现
    //所以在release模式下就没必要进行方法的交换
#ifdef DEBUG
    
    //原本的viewWillAppear方法，class_getInstanceMethod得到实力方法
    Method viewWillAppear = class_getInstanceMethod(self, @selector(viewWillAppear:));
    
    //需要替换成 能够输出日志的viewWillAppear
    Method logViewWillAppear = class_getInstanceMethod(self, @selector(logViewWillAppear:));
    
  Method oriMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method repMethod = class_getInstanceMethod([self class], @selector(replaceDelloc));
    method_exchangeImplementations(oriMethod, repMethod);
    
    //两方法进行交换
    method_exchangeImplementations(viewWillAppear, logViewWillAppear);

#endif
}

- (void)logViewWillAppear:(BOOL)animated {
    
    NSString *className = NSStringFromClass([self class]);
    
    
    NSLog(@"将要出现视图的名字%@",className);
    
    // 此方法是真正的实现了此方法
    [self logViewWillAppear:animated];
}

- (void)replaceDelloc {
    
    NSString *className = NSStringFromClass([self class]);
    
    
    NSLog(@"销毁视图的名字%@",className);
    
    // 此方法是真正的实现了此方法
    [self replaceDelloc];
}
@end
