//
//  MHCreateViewTool.h
//  SuiXingYou
//
//  Created by HelloWorld on 2020/4/1.
//  Copyright © 2020 SuiXingYou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHCreateViewTool : NSObject

+ (UILabel *)createLabelWithText:(NSString * _Nullable)text textColor:(UIColor * _Nullable)textColor font:(UIFont * _Nullable)font alignment:(NSTextAlignment)alignment attributedString:(NSAttributedString * _Nullable)attrStr numberOfLines:(NSInteger)lines;

@end

NS_ASSUME_NONNULL_END
