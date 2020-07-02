//
//  NSString+NSStringUtil.h
//  MobileForParents
//
//  Created by 幼家宝 on 13-3-6.
//  Copyright (c) 2013年 幼家宝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys/utsname.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@interface NSString (NSStringUtil)

+(NSString *)getUUID;
+(NSString *)deviceString;
+ (NSString *)getOSVersion;
//判断是否是整数
+ (BOOL)isPureInt:(NSString *)string;
//判断是否是浮点数
+ (BOOL)isPureFloat:(NSString *)string;
//判断是否是纯数字
+ (BOOL)isNumText:(NSString *)str;

+ (BOOL)isIntText:(NSString *)str;
//验证邮箱合法性
+(BOOL)isValidateEmail:(NSString *)email;
//验证手机号合法性
+(BOOL)isValidateMobile:(NSString *)mobile;
//验证ip地址合法性
+(BOOL)isValidateIP:(NSString *)ip;
//身份证合法性
+(BOOL)isValidateIDCard:(NSString *)idcard;
//验证支付宝付款码
+ (BOOL)validateAliPayCode:(NSString *)code;
//验证微信付款码
+ (BOOL)validateWeiXinCode:(NSString *)code;
//MD5加密
+ (NSString *)md5HexDigest:(NSString *)input;

+(NSString *)getNoHtmlString:(NSString *)htmlStr;


/**
 *  显示不同颜色的字
 */
+(NSMutableAttributedString*)getAttributeTitle:(UIFont *)font :(NSString *)baseText :(NSRange)rang :(BOOL)isColor;

/**
 *自定义cell的高度
 *
 */
+(CGFloat)heightForLabel:(NSString *)str Font:(NSInteger)font;


+(CGFloat)heightForLabel:(NSString *)str Font:(NSInteger)font newWidth:(float)newwidth;

/**
 *  自定义宽度
 */
+(CGFloat)widthForLabel:(NSString *)str Font:(NSInteger)font newHeight:(float)newHeight;



/**
 *
 *获取文件名
 *  */
+(NSString*)getImageName;

/**
 *  让第一字符变红
 */
+(NSMutableAttributedString*)getFirstRedStarWithString:(NSString*)str;

/**
 *  label文案颜色范围划分
 */
+ (NSAttributedString *)showLabelTextColorWithStr:(NSString *)str :(NSInteger)length :(CGFloat)size;

///**
// *  根据str签名
// */
//+(NSString*)getSignWith:(NSString*)str;

/**
 *  限制textFiel只能输入数字,字母和汉字
 */
+(BOOL)isInputRuleNotBlank:(NSString *)str;
/**
 *  去除字符串中图片
 */
+ (NSString *)disable_emoji:(NSString *)text;

/**
 *
 限制汉字输入
 */
+(BOOL)isInPutRuleHANZi:(NSString*)str;
/**
 *验证手机号
  */
+(BOOL)isMobileNumber:(NSString *)mobileNum;
/**
 *  生成特殊字符
 */
+ (NSMutableAttributedString*)getSpecialString:(NSString*)str Rang:(NSRange)range Color:(UIColor*)color Font:(UIFont*)font;
/**
 *  限制小数点
 */
+(BOOL)limitNumPoint:(NSString*)string withPointNum:(NSInteger)num Rang:(NSRange)range textField:(UITextField*)textField;
/**
 *  textField价钱限制
 */
+(BOOL)textField:(UITextField *)textField CharactersInRange:(NSRange)range replacementString:(NSString *)string;

/**
 *  获取今天开始时间
 */

+(NSString*)getToDayStartString;
/**
 *  获取今天时间
 */

+(NSString*)getToDayString;
/**
 *  获取昨天时间
 */

+(NSString*)getYeterDayString;

/**
 *  获取本周时间点
 */
+(NSString*)getThisWeekString;
/**
 *  获取上周时间
 */

+(NSString*)getLastWeekString;
/**
 *  获取本月时间
 */


+(NSString*)getThisMonthString;
/**
 *  获取上月时间
 */

+(NSString*)getLastMonthString;
/**
 *  获取前天时间
 */
+(NSString*)getbeforeYeterDayString;

/**
 *  获取订单号
 */
+(NSString*)getOrderNumWith:(NSString*)machineId userName:(NSString*)userName;

/**
 *  requestID
 */
+ (NSString *)getGoodsCouponRequestID;

+(NSString*)getOrderNumWith:(NSString*)shopperId;
/**
 *  将需要的时间转化成字符串
 */
+(NSString*)getDateString:(NSDate*)date;
/**
 *  一个月以后的时间
 */
+(NSDate*)getOneMonthLaterDateWithDate:(NSDate*)date;
/**
 *  一个月以前的时间
 */
+(NSDate*)getOneMonthAgoDateWithDate:(NSDate*)date;

+ (NSString *)getSevenDaysDateWithCreateTime:(NSDate *)createTime;
//字符串转date
+ (NSDate *)getDateWithCreateTime:(NSString *)createTime;

//把字符串转成两位小数的钱
+ (NSString *)moneyStr:(id)str;


//字符串转时间戳 如：2017-4-10 17:15:10
- (NSString *)getTimeStrWithString:(NSString *)str;

- (NSURL *)urlScheme:(NSString *)scheme;

- (NSString *)stringDecode;

+ (NSString *)getCountStringWithCount:(NSInteger)count;
+ (NSString *)getTimeStrWithString:(NSString *)str;
+ (NSString *)getTimeStringWithString:(NSString *)dateString;
+ (NSString*)deviceVersion;

+ (NSAttributedString *)configureAttributeStringWithString:(NSString *)str rangeAry:(NSArray <NSString *> *)rangeAry font:(UIFont *)font color:(UIColor *)color;
@end
