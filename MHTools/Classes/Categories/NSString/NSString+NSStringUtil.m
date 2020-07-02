//
//  NSString+NSStringUtil.m
//  MobileForParents
//
//  Created by 幼家宝 on 13-3-6.
//  Copyright (c) 2013年 幼家宝. All rights reserved.
//
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <sys/utsname.h>
#import "NSString+NSStringUtil.h"
#import "MHBaseScreen.h"
//#import "MHBaseConfigure.h"
#import "MHDateChange.h"

//#define KScreenWidth [UIScreen mainScreen].bounds.size.width
//#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation NSString (NSStringUtil)
+(NSString*)getUUID{
    // 读取保存的UUID
    NSString*myUUID = [[NSUserDefaults standardUserDefaults] valueForKey:@"my_only_one_UUID"];
    if (myUUID) {
        return myUUID;
    }
    
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    // 读取保存的保存创建的UUID
    [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"my_only_one_UUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return result;
}
+(NSString*)deviceString{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceString;
}
+ (NSString*)getOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
+ (BOOL)isNumText:(NSString *)str{
    NSString * regex        = @"^[0-9]{11}$";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isIntText:(NSString *)str{
    NSString * regex        = @"^[0-9]*$";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//支付宝付款码
+ (BOOL)validateAliPayCode:(NSString *)code{
    NSString *codeRegex = @"^(2[5-9]|30)\\d{14,22}$";
    NSPredicate *codePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codePredicate evaluateWithObject:code];
}

//微信付款码
+ (BOOL)validateWeiXinCode:(NSString *)code{
    NSString *codeRegex = @"^1([0-5])\\d{16}$";
    NSPredicate *codePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codePredicate evaluateWithObject:code];
}

+(BOOL)isValidateIP:(NSString*)ip{
    NSString *ipRegex = @"\\b((?:\\d{1,3}\\.){3}\\d{1,3})(?:/(\\d{1,2}))?\\b";
    NSPredicate *ipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ipRegex];
    return [ipTest evaluateWithObject:ip];
}
+(BOOL)isValidateIDCard:(NSString*)idcard{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:idcard];
}
+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
+(NSString*)getNoHtmlString:(NSString*)htmlStr{
    NSString*result=nil;
    result=[htmlStr stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    result=[result stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    result=[result stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    result=[result stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    return result;
}

+(NSMutableAttributedString*)getAttributeTitle:(UIFont*)font :(NSString*)baseText :(NSRange)rang :(BOOL)isColor{
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
//    NSRange rang = NSMakeRange(4, baseText.length-4);
    NSMutableAttributedString * title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",baseText] attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle}];
    if (isColor) {
        
        [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.000 green:0.455 blue:0.000 alpha:1.000] range:rang];
        
    }
    
    return title;
    
}

+(CGFloat)heightForLabel:(NSString*)str Font:(NSInteger)font
{
    CGRect rect  = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
}
+(CGFloat)heightForLabel:(NSString*)str Font:(NSInteger)font newWidth:(float)newwidth
{
    CGRect rect  = [str boundingRectWithSize:CGSizeMake(newwidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
//    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(newwidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return rect.size.height;
}

+(CGFloat)widthForLabel:(NSString*)str Font:(NSInteger)font newHeight:(float)newHeight{
    CGRect rect  = [str boundingRectWithSize:CGSizeMake(MAXFLOAT,newHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.width;

}

+(NSString*)getImageName{
//    NSDateFormatter*df=[[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSString*nowTime=[df stringFromDate:[NSDate date]];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSInteger time1 = time/1;
//    NSLog(@"++++%ld",time1);
    return [NSString stringWithFormat:@"%ld.jpg",time1];
    
}


+(NSMutableAttributedString*)getFirstRedStarWithString:(NSString*)str{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    //设置：在0-1个单位长度内的内容显示成红色
    if ([[str substringToIndex:1] isEqualToString:@"*"]) {
        [string addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#FF7D26"] range:NSMakeRange(0, 1)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 1)];
    }else{
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 1)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 1)];
    }
    
    return string;
    
    
}

// label文案颜色范围划分
+ (NSAttributedString *)showLabelTextColorWithStr:(NSString *)str :(NSInteger)length :(CGFloat)size {
    NSMutableAttributedString *headerStr = [[NSMutableAttributedString alloc] initWithString: [str substringToIndex:length]];//从零开始截取到length的位置
    [headerStr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size],
                               NSForegroundColorAttributeName:[self colorWithHexString:@"#808080"]
                               }
                       range:NSMakeRange(0, headerStr.length)];
    NSMutableAttributedString *detailStr = [[NSMutableAttributedString alloc] initWithString:str.length>length? [str substringFromIndex:length] : @""];//从length的位置截取到最后
    
    [detailStr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size],
                               NSForegroundColorAttributeName:[self colorWithHexString:@"#FF6130"]
                               }
                       range:NSMakeRange(0, detailStr.length)];
    [headerStr appendAttributedString:detailStr];
    return headerStr;
}

+ (NSMutableAttributedString*)getSpecialString:(NSString*)str Rang:(NSRange)range Color:(UIColor*)color Font:(UIFont*)font{
    NSMutableAttributedString * attriButStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attriButStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attriButStr addAttribute:NSFontAttributeName value:font range:range];
    
    return attriButStr;
}


/**
 *根据str签名
 */
//+(NSString*)getSignWith:(NSString*)str{
//
//    return  [NSString stringWithFormat:@"%@%@%@%@",COMMONCODE,str,PUBLICKEY,SPECIALCODE];
//
//
//}

/**
 *  限制textField输入字母,数字,和汉字
 */
+(BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

/**
 *
 限制汉字输入
 */
+(BOOL)isInPutRuleHANZi:(NSString*)str{
    NSString *pattern = @"^[\u4E00-\u9FA5]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
    
    
}
/**
 *  去除字符串中图片
 */
+ (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}


/**
 *  限制手机号
 */
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^[1]([3][0-9]{1}|[4][0-9]{1}|5[0-3]{1}|5[5-9]{1}|8[0-9]{1}|7[0-9]{1})[0-9]{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *  限制小数点输入
 */
+(BOOL)limitNumPoint:(NSString*)string withPointNum:(NSInteger)num Rang:(NSRange)range textField:(UITextField*)textField{
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag=0;
    const NSInteger limited = num;
    for (int i =(int)(futureString.length-1) ; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                return NO;
            }
            
            break;
        }
        flag++;
    }
    NSString *newstring =[textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *arrayOfString =[newstring componentsSeparatedByString:@"."];
    if ([arrayOfString count] >2) {
        return NO ;
    }
 
    return YES;
}

/**
 *  获取今天开始时间
 */

+(NSString*)getToDayStartString{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * nowStr = [[formatter stringFromDate:[NSDate date]] substringToIndex:10];
    nowStr = [nowStr stringByAppendingString:@" 00:00:00"];
    
    NSDate * newDate = [formatter dateFromString:nowStr];
    return  [[formatter stringFromDate:newDate] substringToIndex:19];
}

/**
 *  获取今天时间
 */

+(NSString*)getToDayString{
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [[formatter stringFromDate:[NSDate date]] substringToIndex:19];
    
}

/**
 *  获取昨天时间
 */

+(NSString*)getYeterDayString{
    NSCalendar *cal =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSDateComponents *components = [cal components:( NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[NSDate date]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * nowStr = [[formatter stringFromDate:[NSDate date]] substringToIndex:10];
    nowStr = [nowStr stringByAppendingString:@" 00:00:00"];
    
    NSDate * newDate = [formatter dateFromString:nowStr];
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: newDate options:0];
    
    return [[formatter stringFromDate:yesterday] substringToIndex:19];
    
}
/**
 *  获取本周时间点
 */
+(NSString*)getThisWeekString{
    NSCalendar *cal =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSDateComponents *components = [cal components:( NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[NSDate date]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * nowStr = [[formatter stringFromDate:[NSDate date]] substringToIndex:10];
    nowStr = [nowStr stringByAppendingString:@" 00:00:00"];
    
    NSDate * newDate = [formatter dateFromString:nowStr];
    components = [cal components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  | NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:newDate];
    [components setDay:([components day] - ([components weekday] -2))];
    NSDate *thisWeek  = [cal dateFromComponents:components];
    return [[formatter stringFromDate:thisWeek] substringToIndex:19];
    
}
/**
 *  获取上周时间
 */

+(NSString*)getLastWeekString{
    NSCalendar *cal =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSDateComponents *components = [cal components:( NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[NSDate date]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * nowStr = [[formatter stringFromDate:[NSDate date]] substringToIndex:10];
    nowStr = [nowStr stringByAppendingString:@" 00:00:00"];
    
    NSDate * newDate = [formatter dateFromString:nowStr];
    components = [cal components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  | NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:newDate];
    
    [components setDay:([components day] - ([components weekday] -2))-7];
    
    NSDate *lastWeek  = [cal dateFromComponents:components];
    return [[formatter stringFromDate:lastWeek] substringToIndex:19];
    
    
}

/**
 *  获取本月时间
 */


+(NSString*)getThisMonthString{
    NSCalendar *cal =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSDateComponents *components = [cal components:( NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[NSDate date]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * nowStr = [[formatter stringFromDate:[NSDate date]] substringToIndex:8];
    nowStr = [nowStr stringByAppendingString:@"01 00:00:00"];
//    NSDate * newDate = [formatter dateFromString:nowStr];
//    
//    
//    components = [cal components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  | NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:newDate];
//    [components setDay:3];
//    NSDate *thisMonth  = [cal dateFromComponents:components];
    
    return nowStr;
    
    
}

/**
 *  获取上月时间
 */

+(NSString*)getLastMonthString{
    NSCalendar *cal =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSDateComponents *components = [cal components:( NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[NSDate date]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * nowStr = [[NSString getThisMonthString] substringToIndex:10];
    
    nowStr = [nowStr stringByAppendingString:@" 00:00:00"];
    
    NSDate * newDate = [formatter dateFromString:nowStr];
    components = [cal components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  | NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:newDate];
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth  = [cal dateFromComponents:components];
    NSString * lastMonthStr = [formatter stringFromDate:lastMonth];
    
    return [NSString stringWithFormat:@"%@01 00:00:00",[lastMonthStr substringToIndex:8]];
    
    
}
/**
 *  获取前天时间
 */

+(NSString*)getbeforeYeterDayString{
    NSCalendar *cal =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSDateComponents *components = [cal components:( NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[NSDate date]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * nowStr = [[formatter stringFromDate:[NSDate date]] substringToIndex:10];
    nowStr = [nowStr stringByAppendingString:@" 00:00:00"];
    
    NSDate * newDate = [formatter dateFromString:nowStr];
    [components setHour:-48];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: newDate options:0];
    
    return [[formatter stringFromDate:yesterday] substringToIndex:19];
    
}

/**
 *  生成订单号 201706191053560000976495936
 */
+ (NSString*)getOrderNumWith:(NSString*)shopperId
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSString *radomStr = @"";
    for (int i = 0 ; i<5; i++) {
        int num = arc4random()%9;
        radomStr = [NSString stringWithFormat:@"%@%d",radomStr,num];
    }
    NSString *baseStr = [NSString stringWithFormat:@"%@%@",[NSString strAppendingNumberWithStr:shopperId withlength:8],radomStr];
    NSMutableString *baseBinary = [NSMutableString stringWithString:[NSString toBinarySystemWithDecimalSystem:[baseStr integerValue]]];
    //完成移位操作
    NSString *base1Binary = [NSString stringWithFormat:@"00%@", [baseBinary substringToIndex:baseBinary.length - 2]];
    //按位异或操作
    NSString *base2Str = [NSString getDecimalByBinary:[NSString baseStr:baseBinary withBase1Str:base1Binary]];
//    NSLog(@"order%@",[NSString stringWithFormat:@"%@%@",dateTime,[NSString strAppendingNumberWithStr:base2Str withlength:13]]);
    return [NSString stringWithFormat:@"%@%@",dateTime,[NSString strAppendingNumberWithStr:base2Str withlength:13]];
}

+ (NSString *)strAppendingNumberWithStr:(NSString *)base1Str withlength:(NSInteger)length
{
    if (base1Str.length < length) {
        NSMutableString *mutableStr = [NSMutableString stringWithString:base1Str];
        for (int i = 0; i < length; i++) {
            [mutableStr insertString:@"0" atIndex:0];
            if (mutableStr.length == length) {
                return mutableStr;
            }
        }
    }
    return base1Str;
}

//十进制转二进制
+ (NSString *)toBinarySystemWithDecimalSystem:(NSInteger)decimal
{
    NSInteger num = decimal;//[decimal intValue];
    NSInteger remainder = 0;      //余数
    NSInteger divisor = 0;        //除数
    
    NSString * prepare = @"";
    
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%ld",remainder];
        
        if (divisor == 0)
        {
            break;
        }
    }
    
    NSString * result = @"";
    for (NSInteger i = prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    
    return result;
}

//  二进制转十进制
+ (NSString *)getDecimalByBinary:(NSString *)binary {
    
    NSInteger decimal = 0;
    for (int i = 0; i < binary.length; i++) {
        
        NSString *number = [binary substringWithRange:NSMakeRange(binary.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            
            decimal += pow(2, i);
        }
    }
    NSString *result = [NSString stringWithFormat:@"%ld",(long)decimal];
    return result;
}

//按位异或处理
+ (NSString *)baseStr:(NSString *)baseStr withBase1Str:(NSString *)base1Str
{
    if (baseStr.length != base1Str.length)
    {
        return nil;
    }
    const char *basechar = [baseStr UTF8String];
    const char *base1char = [base1Str UTF8String];
    NSString *temp = [[NSString alloc] init];
    for (int i = 0; i < baseStr.length; i++)
    {
        int baseValue = [self charToint:basechar[i]];
        int base1Value = [self charToint:base1char[i]];
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%X",baseValue^base1Value]];
    }
    return temp;
}

+ (int)charToint:(char)tempChar
{
    if (tempChar >= '0' && tempChar <='9')
    {
        return tempChar - '0';
    }
    return 0;
}

//获取RequestID
+ (NSString *)getGoodsCouponRequestID{
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSString *radomStr = @"";
    for (int i = 0; i < 8; i ++) {
        int num = arc4random()%9;
        radomStr = [NSString stringWithFormat:@"%@%d",radomStr,num];
    }
    return [NSString stringWithFormat:@"%@%@",dateTime,radomStr];
}


//字符串转date
+ (NSDate *)getDateWithCreateTime:(NSString *)createTime{
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    return [dateFormat dateFromString:createTime];
}

+ (NSString *)getSevenDaysDateWithCreateTime:(NSDate *)createDate{
    
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    NSDate* theDate = [NSDate dateWithTimeInterval:+oneDay*7 sinceDate:createDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:theDate];
    return dateTime;
}

+ (NSString*)getOrderNumWith:(NSString*)machineId userName:(NSString*)userName
{
    int timer = (int)time(NULL);
    NSString * centerStr= @"";
    NSString * time = [NSString stringWithFormat:@"%d",timer];
    for (int i = 0 ; i<4; i++) {
        int radom = arc4random()%1;
        if (radom == 0) {
            int num = arc4random()%9;
            centerStr = [NSString stringWithFormat:@"%@%d",centerStr,num];
        }else{
            centerStr = [NSString stringWithFormat:@"%@%@",centerStr,[NSString radomEnglishWord]];
        }
        
    }
    NSString * backData = [NSString stringWithFormat:@"%@%@",userName,machineId];
    return [NSString stringWithFormat:@"%@%@%@",time,centerStr,[NSString stringWithHexNumber:[backData DF_hashCode] ]];
}

+ (NSString*)radomEnglishWord
{
    NSArray * englishAry = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    int num = arc4random()%25;
    return englishAry[num];
    
}
- (int)DF_hashCode
{
    int hash = 0;
    for (int i = 0; i<[self length]; i++) {
        NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
        char *unicode = (char *)[s cStringUsingEncoding:NSUnicodeStringEncoding];
        int charactorUnicode = 0;
        size_t length = strlen(unicode);
        for (int n = 0; n < length; n ++) {
            charactorUnicode += (int)((unicode[n] & 0xff) << (n * sizeof(char) * 8));
        }
        hash = hash * 31 + charactorUnicode;
    }
    
    return hash;
}


//十进制转16进制
+(NSString *)stringWithHexNumber:(NSUInteger)hexNumber{
    if (hexNumber==0) {
        return nil;
    }
    NSInteger num =  [[NSString stringWithFormat:@"%ld",hexNumber] length];
    char hexChar[num];
    sprintf(hexChar, "%x", (int)hexNumber);
    
    NSString *hexString = [NSString stringWithCString:hexChar encoding:NSUTF8StringEncoding];
    
    return hexString;
}
/**
 *  将需要的时间转化成字符串
 */
+(NSString*)getDateString:(NSDate*)date{
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [[dateFormatter stringFromDate:date] substringToIndex:10];
    
    
}

+(NSDate*)getOneMonthLaterDateWithDate:(NSDate*)date{
    NSTimeInterval timeCount = [date timeIntervalSince1970];
    NSTimeInterval oneMonthTimeCount = timeCount + 30*24*60*60;
    return  [NSDate dateWithTimeIntervalSince1970:oneMonthTimeCount];
    
    
}

+(NSDate*)getOneMonthAgoDateWithDate:(NSDate*)date{
    
    NSTimeInterval timeCount = [date timeIntervalSince1970];
    NSTimeInterval oneMonthTimeCount = timeCount - 30*24*60*60;
    return [NSDate dateWithTimeIntervalSince1970:oneMonthTimeCount];
}

+(BOOL)textField:(UITextField *)textField CharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL _isHaveDian = YES;
    BOOL _isFirstZero = YES;
   
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        _isHaveDian = NO;
    }
    if ([textField.text rangeOfString:@"0"].location==NSNotFound) {
        _isFirstZero = NO;
    }
    
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];
        if ((single >='0' && single<='9') || single=='.')
        {
            
            if([textField.text length]==0){
                if(single == '.'){
                    
                    return NO;
                }
                if (single == '0') {
                    _isFirstZero = YES;
                    return YES;
                }
            }
            
            if (single=='.'){
                if(!_isHaveDian)
                {
                    _isHaveDian=YES;
                    return YES;
                }else{
                    return NO;
                }
            }else if(single=='0'){
                if ((_isFirstZero&&_isHaveDian)||(!_isFirstZero&&_isHaveDian)) {
                    
                    if([textField.text isEqualToString:@"0.0"]){
                        return NO;
                    }
                    NSRange ran=[textField.text rangeOfString:@"."];
                    int tt=(int)(range.location-ran.location);
                    if (tt <= 2){
                        return YES;
                    }else{
                        return NO;
                    }
                }else if (_isFirstZero&&!_isHaveDian){
                    
                    return NO;
                }else{
                    return YES;
                }
            }else{
                if (_isHaveDian){
                    
                    NSRange ran=[textField.text rangeOfString:@"."];
                    int tt= (int)(range.location-ran.location);
                    if (tt <= 2){
                        return YES;
                    }else{
                        return NO;
                    }
                }else if(_isFirstZero&&!_isHaveDian){
                    
                    return NO;
                }else{
                    return YES;
                }
            }
        }else{
            //输入的数据格式不正确
            return NO;
        }
    }else{
        return YES;
    }
    
    return YES;
}

+ (NSString *)moneyStr:(id)str {
    if ([str isKindOfClass:[NSString class]]||[str isKindOfClass:[NSNumber class]]) {
       return  [NSString stringWithFormat:@"%.2f",[str floatValue]];
    }else {
        return @"0.00";
    }
    
}


//字符串转时间戳 如：2017-4-10 17:15:10
- (NSString *)getTimeStrWithString:(NSString *)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970] * 10];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}


- (NSURL *)urlScheme:(NSString *)scheme {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:self] resolvingAgainstBaseURL:NO];
    components.scheme = scheme;
    return [components URL];
}

- (NSString *)stringDecode {
    NSString *str = [self stringByRemovingPercentEncoding];
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
//字符串转时间戳 如：2017-4-10 17:15:10
+ (NSString *)getTimeStrWithString:(NSString *)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}

+ (NSString *)getCountStringWithCount:(NSInteger)count {
    if (count > 9999) {
        double fansCount = count / 10000.0;
        return [NSString stringWithFormat:@"%.1f万", fansCount];
    } else {
        if (count <= 0) {
            return @"0";
        } else {
            NSString *str = [NSString stringWithFormat:@"%ld", (long)count];
            return str;
        }
    }
}
//
+ (NSString *)getTimeStringWithString:(NSString *)dateString {
    NSInteger min = [MHDateChange getMinuteWithTimeStr:dateString];
    NSInteger day = min / 60 / 24;
    if (day > 14) {
        return dateString;
    } else if (day <= 14 && day > 0) {
        return [NSString stringWithFormat:@"%ld天前", day];
    } else if (floor(min / 60) > 0) {
        return [NSString stringWithFormat:@"%ld小时前", min / 60];
    } else if (min > 0) {
        return [NSString stringWithFormat:@"%ld分钟前", (long)min];
    } else {
        return @"刚刚";
    }
}

+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",deviceString);
    NSString * phoneType = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
//    MHLog(@"%@",phoneType);
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    return deviceString;
}

+ (NSAttributedString *)configureAttributeStringWithString:(NSString *)str rangeAry:(NSArray <NSString *> *)rangeAry font:(UIFont *)font color:(UIColor *)color {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [rangeAry enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(NSRangeFromString(obj).location != NSNotFound, @"需要出入string类型的数组");
        [attr addAttributes:@{
            NSFontAttributeName : font,
            NSForegroundColorAttributeName : color
        } range:NSRangeFromString(obj)];
    }];
    return attr;
}

+ (UIColor *)colorWithHexString:(NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];

}
@end
