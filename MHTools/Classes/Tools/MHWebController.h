//
//  MHWebController.h
//  SuiXingYou
//
//  Created by HelloWorld on 2019/1/10.
//  Copyright © 2019 SuiXingYou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, URLType) {
    URLTypeHomeBanner
};

NS_ASSUME_NONNULL_BEGIN

@interface MHWebController : UIViewController

@property (nonatomic, assign) URLType urlType;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) void (^callBack)(void);
@end

NS_ASSUME_NONNULL_END
