//
//  MHCreateViewTool.m
//  SuiXingYou
//
//  Created by HelloWorld on 2020/4/1.
//  Copyright © 2020 SuiXingYou. All rights reserved.
//

#import "MHCreateViewTool.h"


@interface MHCreateViewTool ()
@end

@implementation MHCreateViewTool
+ (UILabel *)createLabelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment attributedString:(NSAttributedString *)attrStr numberOfLines:(NSInteger)lines {
    UILabel *lab = [UILabel new];
    lab.text = text;
    lab.textColor = textColor;
    lab.font = font;
    lab.textAlignment = alignment;
    if (attrStr.length) {
        lab.attributedText = attrStr;
    }
    lab.numberOfLines = lines;
    return lab;
}
@end
