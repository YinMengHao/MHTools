//
//  HQGeneralUtil.m
//  ODispatch
//
//  Created by 石峰 on 2017/2/13.
//  Copyright © 2017年 MengoTech. All rights reserved.
//

#import "HQGeneralUtil.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import <ExternalAccessory/ExternalAccessory.h> // wifi 蓝牙框架
#import <ifaddrs.h>
#import <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <sys/utsname.h>
#import <UserNotifications/UserNotifications.h>
#import "UIView+Toast.h"
#import <Accelerate/Accelerate.h>
#import "MHBaseConfigure.h"
//#import "MHBaseLibrary.h"
//#import "MHBaseScreen.h"
#import <UIKit/UIKit.h>

@interface HQGeneralUtil ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;


@end

@implementation HQGeneralUtil

+ (HQGeneralUtil *)shareInstance
{
    static HQGeneralUtil *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

/** 获取当前手机时间 */
+ (NSString *)getCurrentPhoneTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}



/** 获取当前手机时间(YYYY-MM-dd) */
+ (NSString *)getCurrentPhoneTime1{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}

/** 获取时间 fotmatter是时间格式例如：(YYYY-MM-dd) */
+ (NSString *)getDateWithFormat:(NSString *)fotmatter{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:fotmatter];
    
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}

/** 将传入的时间转成对应的格式 fotmatter是时间格式例如：(YYYY-MM-dd)（需要转的格式） */
+ (NSString *)getDateWithFormat:(NSString *)fotmatter date:(NSString *)date{
	
	NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
	[formatter1 setDateFormat:@"yyyy/M/d"];
	NSDate *needDate = [formatter1 dateFromString:date];
	
	NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
	[formatter0 setDateFormat:fotmatter];
	
	NSString *currentTimeString = [formatter0 stringFromDate:needDate];
	
	return currentTimeString;
}

/** 获取一个随机数*/
+ (NSString *)getRandomNumbStr
{
    //时间戳
    long t = time(NULL);
    int ran = arc4random_uniform(8999) + 1000;
    return [NSString stringWithFormat:@"%ld",t+ran];
}

/** 获取wifi名称（真机有效）*/
+ (NSString *)getCurrentWifiSSID
{
    NSString *wifiName = nil;
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    for (NSString *ifname in ifs)
    {
        NSDictionary *info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        if (info[@"SSID"])
        {
            wifiName = info[@"SSID"];
        }
    }
    return wifiName;
}

/** 获取当前版本号*/
+ (NSString *)getCurrentVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/** 计算两点距离*/
+ (double)getDistanceBetween2Points:(CGPoint)firstP otherPoint:(CGPoint)secondP
{
    CGFloat deltaX = firstP.x - secondP.x;
    CGFloat deltaY = firstP.y - secondP.y;
    return sqrt(deltaX * deltaX + deltaY * deltaY);
}

/** 检测手机号合法性*/
+ (BOOL)isLegalPhoneNumber:(NSString *)numberStr
{
//    NSString *regex = @"^((13[0-9])|(19[0-9])|(15[^4,\\D])|(18[0-9])|(17[0,3,7-8]))\\d{8}$";
//    NSString *regex = @"^1[3,4,5,6,7,8,9][0-9]{9}$";
    NSString *regex = @"^1[0,1,2,3,4,5,6,7,8,9][0-9]{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:numberStr];
    if (isMatch) {
        
        if (numberStr.length == 11) {
            
            isMatch = YES;
        }else {
            
            isMatch = NO;
        }
    }
    return isMatch;
}

/** 判断纯数字*/
+ (BOOL)isPureInt:(NSString *)str
{
    NSScanner* scan = [NSScanner scannerWithString:str];
    int val;
    float valF;
    return ([scan scanInt:&val] && [scan isAtEnd]) || ([scan scanFloat:&valF] && [scan isAtEnd]);
}


/** 播放开锁声音*/
+ (void)playSoundIsScuess:(BOOL)success
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:success ? @"ring.mp3" : @"fail.wav" ofType:nil];
    NSURL *soundURL = [NSURL URLWithString:soundFilePath];
    
    NSError *error;
    
    [self shareInstance].audioPlayer = nil;
    [self shareInstance].audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    
    if (error)
    {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else
    {
        [[self shareInstance].audioPlayer prepareToPlay];
    }
    
    //播放
    [[self shareInstance].audioPlayer play];
}

/** md5加密*/
+ (NSString *)md5Encryption:(NSString *)orignalStr
{
    const char *original_str = [orignalStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *encodeStr = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [encodeStr appendFormat:@"%02X", result[i]];
    }
    return [encodeStr lowercaseString];
}

/** 距离 (单位为米) */
+ (double)distanceBetweenCor1:(CLLocationCoordinate2D)cor1 Cor2:(CLLocationCoordinate2D)cor2
{
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:cor1.latitude longitude:cor1.longitude];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:cor2.latitude longitude:cor2.longitude];
    return [curLocation distanceFromLocation:otherLocation];
}

/** 时间戳转年月日*/
+ (NSString *)timeStrTransformToDateStr:(NSString *)timeStr
{
    if (!timeStr.length)
    {
        return @"未知";
    }
    
    //毫秒时间戳
    timeStr = [NSString stringWithFormat:@"%.0f",timeStr.floatValue/1000];
    
    //时间戳转日期 (秒数转日期)
    NSDate *data = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // HH 为24 小时制 hh 为12小时制
    formatter.dateFormat = @"yyyy-M-d";
    
    NSString *resStr = [formatter stringFromDate:data];
    NSArray *arr = [resStr componentsSeparatedByString:@"-"];
    
    if (arr.count != 3)
    {
        //时间戳转换失败
        return @"未知";
    }
    else
    {
        return resStr;
    }
}

/// 根据指定date获取对应时间戳(精确到秒)  YY_添加
+ (NSTimeInterval)getTimestampSecondPrecisionWithDate:(NSDate *)date {
    
    NSTimeInterval currentTImeSign = [date timeIntervalSince1970] * 1000;
    
    return currentTImeSign;
    
}

/// 计算给定时间与当前时间的距离  YY_添加
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [self getTimestampSecondPrecisionWithDate:[NSDate date]];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        distanceStr = @"刚刚";
    }
    else if (distanceTime <60*60) {//时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }
    else if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }
    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
        
    }
    else if(distanceTime <24*60*60*365){
        [df setDateFormat:@"MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}


#pragma mark ---------------SF添加-----------
/*! 获取当前时间的时间戳 SF添加 */
+ (NSString*)sf_getCurrentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

/*!  
 计算给定时间与当前时间的距离  SF_添加
 beTime 为传入的时间戳
 */
+ (NSString *)sf_distanceTimeWithBeforeTime:(NSString *)beTimeStamp {
    
    

    // 获取当前的时间戳
    NSString *currentTimeStamp = [self sf_getCurrentTimestamp];
    if (currentTimeStamp.length >= 13) {
        
        currentTimeStamp = [NSString stringWithFormat:@"%.f",currentTimeStamp.doubleValue / 1000];
    }
    
    if (beTimeStamp.length >= 13) {
        
        beTimeStamp = [NSString stringWithFormat:@"%.f",beTimeStamp.doubleValue / 1000];
    }
    NSLog(@"当前时间的时间戳===%@",beTimeStamp);
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTimeStamp.doubleValue];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    [df setDateFormat:@"dd"];
    
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];

    CGFloat distanceTimeSeconds = currentTimeStamp.doubleValue -beTimeStamp.doubleValue;
    NSString *distanceStr = @"";
    if (distanceTimeSeconds < 60) { // 小于一分钟
        
        distanceStr = @"刚刚";
    }else if (distanceTimeSeconds < 60*60) { // 时间小于一个小时
        
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTimeSeconds/60];
    }else if(distanceTimeSeconds <= 24*60*60*2 + 10){//时间小于二天 (10代表的是服务器返回的时间和手机时间的误差)
        
        if ([nowDay isEqualToString:lastDay]) {
            
            distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
        }else {
            
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        
    }else if(distanceTimeSeconds < 24*60*60*365){
        
        [df setDateFormat:@"MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}


#pragma mark ---------------------获取文字首字母-----------------
//获取字符串首字母(传入汉字字符串, 返回大写拼音首字母，如果传入的是空，返回K)
+ (NSString *)getFirstLetterFromString:(NSString *)aString
{
    NSString *tempStr = @"K";
    if ([aString isEqualToString:@""] || aString == nil) {
        
        return tempStr;
    }
    
    if ([self isChineseCharacters:aString]) { // 是汉字
        
        if (aString && aString.length > 0) {
            
            //转成了可变字符串
            NSMutableString *str = [NSMutableString stringWithString:aString];
            //先转换为带声调的拼音
            CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
            //再转换为不带声调的拼音
            CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
            //转化为大写拼音
            NSString *strPinYin = [str capitalizedString];
            //获取并返回首字母
            return [strPinYin substringToIndex:1];
        }else {
            
            return tempStr;
        }
    }
        
    if (aString.length > 0) { // 是英文
            
        NSMutableString *englishStr = [aString uppercaseString].mutableCopy;
        
        return [englishStr substringToIndex:1];
    }else {
            
        return tempStr;
    }
    
}

// 判断首字母是汉字还是字母
+ (BOOL)isChineseCharacters:(NSString *)str {
    
    if(str && ![str isEqualToString:@""] && str.length > 0){
        
        NSRange range=NSMakeRange(0,1);
        NSString *subString=[str substringWithRange:range];
        const char *cString=[subString UTF8String];
        if (strlen(cString)==3)
        {
            NSLog(@"昵称是汉字");
            return YES;
        }else if(strlen(cString)==1){
            NSLog(@"昵称是字母");
            return NO;
        }
    }
    
    // 字符串不存在或为空的时候都算是汉字
    return YES;
}



//-------------------------------二维码、条形码生成------------------------------


/** 生成条形码 Bar Code */
+ (UIImage *)createBarCodeImageWithInfo:(NSString *)infoStr size:(CGSize)size
{
    // iOS 8.0 以上支持 注意生成条形码的编码方式
    NSData *data = [infoStr dataUsingEncoding:NSASCIIStringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    
    // 设置生成的条形码的上，下，左，右的margins的值
    [filter setValue:[NSNumber numberWithInteger:0] forKey:@"inputQuietSpace"];
    
    return [self resizeCodeImage:filter.outputImage withSize:size];
}

/** 生成二维码 QRCode */
+ (UIImage *)createQRCodeImageWithInfo:(NSString *)infoStr size:(CGSize)size
{
    NSData *data = [infoStr dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    
    // 错误修正容量
    // L水平 7%的字码可被修正
    // M水平 15%的字码可被修正
    // Q水平 25%的字码可被修正
    // H水平 30%的字码可被修正
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    
    return [self resizeCodeImage:filter.outputImage withSize:size];
}

/**
 *  调整生成的图片的大小(清晰化)
 *
 *  @param image CIImage对象
 *  @param size  需要的UIImage的大小
 *
 *  @return size大小的UIImage对象
 */
+ (UIImage *)resizeCodeImage:(nonnull CIImage *)image withSize:(CGSize)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
    CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
    size_t width = CGRectGetWidth(extent) * scaleWidth;
    size_t height = CGRectGetHeight(extent) * scaleHeight;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
    CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
    CGContextDrawImage(contentRef, extent, imageRef);
    CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
    CGContextRelease(contentRef);
    CGImageRelease(imageRef);
    return [UIImage imageWithCGImage:imageRefResized];
    
//    // 消除模糊方案2
//    CGFloat scaleX = size.width / image.extent.size.width; // extent 返回图片的frame
//    CGFloat scaleY = size.height / image.extent.size.height;
//    CIImage *transformedImage = [image imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
//    return [UIImage imageWithCIImage:transformedImage];
}

//-------------------------------七牛相关------------------------------

/** 获取七牛 图片名*/
+ (NSString *)getQiNiuImageName
{
    //时间戳
    long t = time(NULL);
    //四位随机数
    int ran = arc4random_uniform(8999) + 1000;
    
    return [NSString stringWithFormat:@"%ld%d.jpeg",t,ran];
}

/** 获取七牛 语音文件名*/
+ (NSString *)getQiNiuAudioFileName
{
    //时间戳
    long t = time(NULL);
    //四位随机数
    int ran = arc4random_uniform(8999) + 1000;
    
    return [NSString stringWithFormat:@"%ld%d.mp3",t,ran];

}

//-------------------------------类型修正------------------------------
+ (void)amendDicValueIsNSString:(NSMutableDictionary *)dic
{
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop)
     {
         //不是NSString
         if (![value isKindOfClass:[NSString class]])
         {
             if ([value isKindOfClass:[NSArray class]])
             {
                 NSMutableArray *muArr = [NSMutableArray arrayWithArray:value];
                 [dic setValue:muArr forKey:key];
                 [self amendArrValueIsNSString:muArr];
             }
             else if ([value isKindOfClass:[NSDictionary class]])
             {
                 NSMutableDictionary *smallDic = [NSMutableDictionary dictionaryWithDictionary:value];
                 [dic setValue:smallDic forKey:key];
                 [self amendDicValueIsNSString:smallDic];
             }
             else if ([value isKindOfClass:[NSNumber class]])
             {
                 //NSNumber 转 NSString
                 NSNumber *numberV = value;
                 [dic setValue:[NSString stringWithFormat:@"%@",decimalNumberWithDouble(numberV.doubleValue)] forKey:key];
             }
             else if ([value isKindOfClass:[NSNull class]])
             {
                 //NSNull 转 NSString
                 [dic setValue:@"" forKey:key];
             }
             else
             {
                 //不是string && 不是arr && 不是Null
                 NSLog(@"检测结果：%@的值无法修正,真实类型为：%@",key,[value class]);
             }
         }
     }];
}

/** 处理精度丢失问题函数*/
NSString *decimalNumberWithDouble(double conversionValue)
{
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

+ (void)amendArrValueIsNSString:(NSMutableArray *)arr
{
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (![obj isKindOfClass:[NSString class]])
         {
             //不是NSString
             if ([obj isKindOfClass:[NSArray class]])
             {
                 NSMutableArray *smallArr = [NSMutableArray arrayWithArray:obj];
                 [arr replaceObjectAtIndex:idx withObject:smallArr];
                 [self amendArrValueIsNSString:smallArr];
             }
             else if ([obj isKindOfClass:[NSDictionary class]])
             {
                 NSMutableDictionary *smallDic = [NSMutableDictionary dictionaryWithDictionary:obj];
                 [arr replaceObjectAtIndex:idx withObject:smallDic];
                 [self amendDicValueIsNSString:smallDic];
             }
             else if ([obj isKindOfClass:[NSNumber class]])
             {
                 //NSNumber 转 NSString
                 [arr replaceObjectAtIndex:idx withObject:[NSString stringWithFormat:@"%@",obj]];
             }
             else if ([obj isKindOfClass:[NSNull class]])
             {
                 //NSNull 转 NSString
                 [arr replaceObjectAtIndex:idx withObject:@""];
             }
             else
             {
                 //不是string && 不是arr && 不是dic && 不是Null
                 NSLog(@"检测结果：值%@无法修正,真实类型为：%@",obj,[obj class]);
             }
         }
     }];
}

/** 字符串转Dic*/
+ (NSDictionary *)amendDicStrToDic:(NSString *)dicStr
{
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[dicStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];

    if ([dic isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self amendDicValueIsNSString:muDic];
        return muDic;
    }
    else
    {
        if (err)
        {
            NSLog(@"字符串转Dic 转换失败：%@",err);
        }
        
        return nil;
    }
}

/** 检测dic中类型是否为string*/
+ (void)checkDicValueIsNSString:(NSDictionary *)dic
{
    for (NSString *key in dic)
    {
        id value = dic[key];
        
        if (![value isKindOfClass:[NSString class]])
        {
            //不是NSString
            if ([value isKindOfClass:[NSArray class]])
            {
                [self checkArrValueIsNSString:value];
            }
            else if ([value isKindOfClass:[NSDictionary class]])
            {
                [self checkDicValueIsNSString:value];
            }
            else
            {
                //不是string && 不是arr && 不是dic
                NSLog(@"检测结果：%@的值不是NSString,真实类型为：%@",key,[value class]);
            }
        }
    }
}

/** 检测arr中类型是否为string*/
+ (void)checkArrValueIsNSString:(NSArray *)arr
{
    for (id obj in arr)
    {
        if (![obj isKindOfClass:[NSString class]])
        {
            //不是NSString
            if ([obj isKindOfClass:[NSArray class]])
            {
                [self checkArrValueIsNSString:obj];
            }
            else if ([obj isKindOfClass:[NSDictionary class]])
            {
                [self checkDicValueIsNSString:obj];
            }
            else
            {
                //不是string && 不是arr && 不是dic
                NSLog(@"检测结果：值%@不是NSString,真实类型为：%@",obj,[obj class]);
            }
        }
    }
}

+(NSAttributedString *)fillDZNEmptyDataSetwithTitle:(NSString *)title textColor:(UIColor *)color{
    
    NSString *text = title?title:@"";
    UIFont *font = [UIFont systemFontOfSize:17];
    UIColor *textColor =color?color:[UIColor colorWithWhite:0.7 alpha:1];
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor)
        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph)
        [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:attributes];
    return attributedString;
    
}

/*! 获取字符串中的的数字（整数） */
+ (NSString *)getPureDigitalFromStr:(NSString *)str {
    if (KIsEmptyStr(str)) {
        
        return @"";
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    
    int number;
    [scanner scanInt:&number];
    NSString *num=[NSString stringWithFormat:@"%d",number];
    return num;
}

/*! 获取字符串中的的数字（浮点数） */
+ (NSString *)getPureDigitalFloatFromStr:(NSString *)str {
    if (KIsEmptyStr(str)) {

        return @"";
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    
    float number;
    [scanner scanFloat:&number];
    NSString *num=[NSString stringWithFormat:@"%f",number];
    return num;
}


#pragma mark ---压缩图片----
/**
 * 图片压缩到指定大小
 * @param targetSize 目标图片的大小
 * @param sourceImage 源图片
 * @return 目标图片
 */
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

// 字典转json字符串方法
+ (NSString *)dicToJsonData:(NSDictionary *)dict{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

/*！ JSON转字典 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


/*! 替换返回的对象中有为nil的字段  */ 
+ (id)replaceNilForObject:(id)object {
    
    if ([object isEqual:[NSNull class]] || [object isEqual:[NSNull null]]) {
        object = (NSString *)object;
        object = nil;
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *tempDict = [object mutableCopy];
        for (id key in object) {
            id value = [self replaceNilForObject:object[key]];
            [tempDict setObject:value forKey:key];
        }
        object = [tempDict copy];
    } else if ([object isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *tempArray = [object mutableCopy];
        
        for (id value in object) {
            id newValue = [self replaceNilForObject:value];
            [tempArray replaceObjectAtIndex:[tempArray indexOfObject:value]
                                 withObject:newValue];
        }
        object = [tempArray copy];
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@" "]) {
            object = @"";
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        
        NSString *d2Str = [NSString stringWithFormat:@"%lf", [object doubleValue]];
        NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:d2Str];
        object  = [num1 stringValue];
        
    }
	if (!object){
		object = @"";
	}
	
    return object;
}

/*! 汉字转拼音 */
+ (NSString *)chinesetransformPinYin:(NSString *)chinese {
    
    if (KIsEmptyStr(chinese)) {
        
        return @"";
    }
    
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin uppercaseString];
}


/*! 空字符串返回 @“” */
+ (NSString *)returnEmptyStr:(NSString *)str {
    
    if (KIsEmptyStr(str)){
        return @"";
    }else {
        return str;
    }
}

/*! 空字符串返回-- */
+ (NSString *)returnLineStr:(NSString *)str {
    
    if (KIsEmptyNil(str)) {
        
        return @"--";
    }else {
        return str;
    }
}

/*! 判断字符串中是否有非法字符 */
+ (BOOL)isHaveIllegalCharacter:(NSString *)str {
    
    NSString *allStr = @"[]{}#%*=\\|~＜＞$%^&*/、？‘’''""`~。，, ";
    __block BOOL isHave = NO;
    for (int i = 0; i < allStr.length; i++) {
        
        if ([str containsString:[allStr substringWithRange:NSMakeRange(i, 1)]]) {
            
            isHave = YES;
            break;
        }
    }
    return isHave;
}

/*!  获取当前控制器 */
+ (UIViewController *)currentViewController;
{
    
    UIViewController *topController =[[UIApplication sharedApplication].delegate window].rootViewController;
    while ([topController presentedViewController])
        topController = [topController presentedViewController];
    
    UIViewController *currentViewController = topController;
    
    while ([currentViewController isKindOfClass:[UITabBarController class]] &&
           [(UITabBarController *)currentViewController selectedViewController])
        currentViewController =
        [(UITabBarController *)currentViewController selectedViewController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] &&
           [(UINavigationController *)currentViewController topViewController])
        currentViewController =
        [(UINavigationController *)currentViewController topViewController];
    
    return currentViewController;
}


/*! 判断是否开启了定位 */
+ (BOOL)judgeLocationServiceEnabled {
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){ // 用户拒绝定位服务
        
        return NO;
    }else {
     
        return YES;
    }
}


/*! 获取IOS的IDFA（广告表示符，用于广告提供商追踪用户而设置的）
 
 广告标示符，适用于对外：例如广告推广，换量等跨应用的用户追踪等。但如果用户完全重置系统（(设置程序 -> 通用 -> 还原 -> 还原位置与隐私) ，这个广告标示符会重新生成。另外如果用户明确的还原广告(设置程序-> 通用 -> 关于本机 -> 广告 -> 还原广告标示符) ，那么广告标示符也会重新生成。注意：如果程序在后台运行，此时用户“还原广告标示符”，然后再回到程序中，此时获取广 告标示符并不会立即获得还原后的标示符。必须要终止程序，然后再重新启动程序，才能获得还原后的广告标示符。在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在 设置 -> 隐私 -> 广告追踪 里重置此id的值，或限制此id的使用。
 
   ios设备真正的唯一标识符UDID已经被禁用[[UIDevice currentDevice] uniqueIdentifier]（ios7已经完全废弃）
 */
+ (NSString *)getDeviceId {
    
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}



/*! 获取wifi的mac地址 */
+ (NSString *)getWifiMacAddress:(WifiInfoType)wifiInfoType {
    
    //1.获取网络底层监视的所有接口列表，返回的是一个BSD接口名称
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        
        //2.通过BSD接口名称获取网络信息，返回的是一个字典。其中包含 1.wifi名称字符串  2.mac地址 3.wifi名称二进制数据
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
 
    //3.获取字典
    NSDictionary *dctySSID = (NSDictionary *)info;
    
    //4.字典的SSID键对应的值就是wifi的名称
    //注意：  1. 模拟器获取不到wifi名称 返回为nil  2.真机的话如果没有连接wifi而是使用4G，返回的也是nil
    NSString *wifiValue = nil;
    if (wifiInfoType == wifiName) {
        
        wifiValue = [dctySSID objectForKey:@"SSID"];//wifi名称
    }else if (wifiInfoType == wifiMacAddress) {
        
        wifiValue = [dctySSID objectForKey:@"BSSID"];//wifimac地址
    }
    
    
    //     NSString *bssid = [dctySSID objectForKey:@"BSSID"];//mac地址，苹果返回的是一个无效的mac地址，与手机实际mac地址不一致，主要用于保护用户隐私
    
    return wifiValue;
}

/*! 字符串比较大小区分大小写 */
+ (StrCompareType)compareStrCaseSensitiveWithFirstStr:(NSString *)firstStr secondStr:(NSString *)secondStr {
    
    if ([firstStr compare:secondStr] == NSOrderedDescending) { // 前者大于后者
        
        return firstBig;
    }else if ([firstStr compare:secondStr] == NSOrderedAscending) {
        
        return firstSmall;
    }else {
        
        return firstEqualSecond;
    }
}

/*! 字符串比较大小不区分大小写 */
+ (StrCompareType)compareStrNoCaseSensitiveWithFirstStr:(NSString *)firstStr secondStr:(NSString *)secondStr {
    
    if ([firstStr caseInsensitiveCompare:secondStr] == NSOrderedDescending) { // 前者大于后者
        
        return firstBig;
    }else if ([firstStr caseInsensitiveCompare:secondStr] == NSOrderedAscending) {
        
        return firstSmall;
    }else {
        
        return firstEqualSecond;
    }
}

//判断WIFI是否打开
+ (BOOL) isWiFiEnabled {
    
    NSCountedSet * cset = [NSCountedSet new];
    struct ifaddrs *interfaces;
    
    if( ! getifaddrs(&interfaces) ) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}

// 为图片添加水印
+ (UIImage *)imageWithWaterImg:(UIImage*)icon_mask WaterChar:(NSString *)icon_char originImg:(UIImage*)mask icon_charSize:(CGFloat)charSize{
    
    UIGraphicsBeginImageContext(mask.size);
    
    //字体倍数 宽度
    NSInteger multiple = mask.size.width/[UIScreen mainScreen].bounds.size.width;
    CGFloat tpW = [self justWidthWithStr:icon_char FontSize:charSize*multiple Limit:charSize*multiple+10];
    
    //原图
    [mask drawInRect:CGRectMake(0, 0, mask.size.width, mask.size.height)];
    
    //文字水印
    NSDictionary *attr = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:charSize*multiple],  //设置字体
                           NSForegroundColorAttributeName : [UIColor whiteColor]   //设置字体颜色
                           };
    
    //
    [icon_char drawInRect:CGRectMake(mask.size.width - 1.1*tpW , mask.size.height -  charSize*multiple - 10 ,  1.1*tpW, charSize*multiple + 10) withAttributes:attr];  //右下角
    //水印图
    //    [icon_mask drawInRect:CGRectMake(mask.size.width - icon_mask.size.width, mask.size.height - icon_mask.size.height, icon_mask.size.width, icon_mask.size.height)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

/*! 获取启动图 */
+ (UIImage *)launchImage {
    
    UIImage    *lauchImage  = nil;
    NSString    *viewOrientation = nil;
    CGSize     viewSize  = [UIScreen mainScreen].bounds.size;
    if (@available (iOS 13.0, *)) {
        UIWindow *window = [UIApplication.sharedApplication.windows objectAtIndex:0];
        UIInterfaceOrientation orientation = window.windowScene.interfaceOrientation;
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            viewOrientation = @"Landscape";
        } else {
            viewOrientation = @"Portrait";
        }
        
    } else {
        // 消除方法弃用(过时)的警告
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        // 要消除警告的代码
        UIInterfaceOrientation orientation  = [[UIApplication sharedApplication] statusBarOrientation];
        #pragma clang diagnostic pop
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            
            viewOrientation = @"Landscape";
            
        } else {
            
            viewOrientation = @"Portrait";
        }
    }
    
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary) {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    
    return lauchImage;
}

/*! 传入字符串数字，将字符串转换成每隔3位加上分隔符逗号的数字 */
+ (NSString *)separateNumberUseCommaWith:(NSString *)number keepDecimalDigits:(NSUInteger)digit{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:digit];
    [numberFormatter setMinimumFractionDigits:digit];
    if (KIsEmptyStr(number)) {
        
        if (digit == 0) {
            
            return @"0";
        }else {
            
            NSString *tempStr = [numberFormatter stringFromNumber:@([@"0.00" floatValue])];
            return [NSString stringWithFormat:@"0%@",tempStr];
        }
        
    }
    
    

    // 分隔符
    NSString *divide = @",";
    NSString *integer = @"";
    NSString *radixPoint = @"";
    BOOL contains = NO;
    if ([number containsString:@"."]) {
        contains = YES;
        // 若传入浮点数，则需要将小数点后的数字分离出来
        NSArray *comArray = [number componentsSeparatedByString:@"."];
        integer = [comArray firstObject];
        radixPoint = [comArray lastObject];
    } else {
        integer = number;
    }
    // 将整数按各个字符为一组拆分成数组
    NSMutableArray *integerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < integer.length; i ++) {
        NSString *subString = [integer substringWithRange:NSMakeRange(i, 1)];
        [integerArray addObject:subString];
    }
    // 将整数数组倒序每隔3个字符添加一个逗号“,”
    NSString *newNumber = @"";
    for (NSInteger i = 0 ; i < integerArray.count ; i ++) {
        NSString *getString = @"";
        NSInteger index = (integerArray.count-1) - i;
        if (integerArray.count > index) {
            getString = [integerArray objectAtIndex:index];
        }
        BOOL result = YES;
        if (index == 0 && integerArray.count%3 == 0) {
            result = NO;
        }
        if ((i+1)%3 == 0 && result) {
            newNumber = [NSString stringWithFormat:@"%@%@%@",divide,getString,newNumber];
        } else {
            newNumber = [NSString stringWithFormat:@"%@%@",getString,newNumber];
        }
    }
    
    
    if (digit == 0) {
        
        newNumber = [NSString stringWithFormat:@"%@",newNumber];
    }else {
        
        if (contains) {
            newNumber = [NSString stringWithFormat:@"%@.%@",newNumber,radixPoint];
        }else {
            NSString *temp0 = @"000000000000000000000000000";
            newNumber = [NSString stringWithFormat:@"%@.%@",newNumber,[temp0 substringWithRange:NSMakeRange(0, digit)]];
        }
    }
    
    return newNumber;
}

/*!
 返回虚线横着image的方法
 everyLineLength:线条每一小截的宽度
 widthOrHeight:如果是横线则是线条的高度，如果是竖线则是线条的宽度
 lineColor:线条颜色
 lineHeadType:线条的头部样式
 lineDirectionType:线条的方向
 drawLineByImageView
 */
+ (UIImage *)drawCrossTypeLineByImageView:(UIImageView *)imageView everyLineLength:(CGFloat)length widthOrHeight:(CGFloat)widthOrHeight lineColor:(UIColor *)color lineHeadType:(CGLineCap)lineHeadType{
    [imageView layoutIfNeeded];
	// 宽高不能小于绘制线条的厚度
	if (imageView.frame.size.height < widthOrHeight) {
		
		widthOrHeight = imageView.frame.size.height;
	}
	
	UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
	[imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
	//设置线条终点形状
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), lineHeadType);
	// 5是每个虚线的长度 1是高度
	const CGFloat lengths[] = {length,widthOrHeight};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, color.CGColor);
    
    CGContextSetLineDash(line, 0, lengths, widthOrHeight); //画虚线
    CGContextMoveToPoint(line, 0.0, widthOrHeight); //开始画线
    CGContextAddLineToPoint(line, imageView.frame.size.width, widthOrHeight);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
	return UIGraphicsGetImageFromCurrentImageContext();
}


/*!
 返回虚线竖直image的方法
 everyLineLength:线条每一小截的宽度
 widthOrHeight:如果是横线则是线条的高度，如果是竖线则是线条的宽度
 lineColor:线条颜色
 lineHeadType:线条的头部样式
 lineDirectionType:线条的方向
 */
+ (UIImage *)drawVerticalTypeLineByImageView:(UIImageView *)imageView everyLineLength:(CGFloat)length widthOrHeight:(CGFloat)widthOrHeight lineColor:(UIColor *)color lineHeadType:(CGLineCap)lineHeadType{

    // 宽高不能小于绘制线条的厚度
    if (imageView.frame.size.width < widthOrHeight) {
        
        widthOrHeight = imageView.frame.size.width;
    }
    
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), lineHeadType);
    // 5是每个虚线的长度 1是高度
    const CGFloat lengths[] = {length,widthOrHeight};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, color.CGColor);
    
    CGContextSetLineDash(line, 0, lengths, widthOrHeight); //画虚线
    CGContextMoveToPoint(line, widthOrHeight, 0); //开始画线
    CGContextAddLineToPoint(line, widthOrHeight, imageView.frame.size.height);
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}


/*!
 日期转星期
 */
+ (NSString*)getWeekDay:(NSString*)currentStr {
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
	
	[dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
	
	NSDate *date =[dateFormat dateFromString:currentStr];
	
	NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null],@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",nil];
	// 使用的是公历
	NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	
	NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
	
	[calendar setTimeZone:timeZone];
	
	NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
	
	NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
	
	return[weekdays objectAtIndex:theComponents.weekday];
}

// 获取某年某月的天数（例如2018-09）
+ (NSString *)getNumberOfDaysInMonth:(NSString *)date
{
	NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSGregorianCalendar - ios 8
	// 日期格式化类
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	// 设置日期格式 为了转换成功
	format.dateFormat = @"yyyy-MM";
	NSDate *currentDate = [format dateFromString:date];
	NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay  //NSDayCalendarUnit - ios 8
								   inUnit: NSCalendarUnitMonth //NSMonthCalendarUnit - ios 8
								  forDate:currentDate];
	return [NSString stringWithFormat:@"%zd",range.length];
}

// 是否安装支付宝
+ (BOOL) isInstallAlipy {
	
	NSURL * myURL_APP_A = [NSURL URLWithString:@"alipays:"];
	if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
		
		return YES;
	}else {
		
		return NO;
	}
}


// 加载sfHUD（能交互的HUD）
+ (void) addSF_ProgressHUD {
    
//    SF_LzdProgressHUD *hud = [SF_LzdProgressHUD sharedHUD];
//    hud.sfHUDMaskType = SF_LzdHUDNoneMask;
//    hud.isUserInteraction = YES;
//    [SF_LzdProgressHUD showSFHUD];
    
    
    
    
//    SF_LzdProgressTwoHUD *hud = [SF_LzdProgressTwoHUD sharedHUD];
//    hud.sfHUDMaskType = SF_LzdHUDNoneMask;
//    hud.isUserInteraction = YES;
//    [SF_LzdProgressTwoHUD showSFHUD];
}

// 加载sfHUD（不能交互的HUD）
+ (void) addSF_ProgressHUD:(BOOL)isUserInteraction {
    
//    SF_LzdProgressHUD *hud = [SF_LzdProgressHUD sharedHUD];
//    hud.sfHUDMaskType = SF_LzdHUDNoneMask;
//    hud.isUserInteraction = isUserInteraction;
//    [SF_LzdProgressHUD showSFHUD];
    
//    SF_LzdProgressTwoHUD *hud = [SF_LzdProgressTwoHUD sharedHUD];
//    hud.sfHUDMaskType = SF_LzdHUDNoneMask;
//    hud.isUserInteraction = isUserInteraction;
//    [SF_LzdProgressTwoHUD showSFHUD];
}

// 移除sfHUD
+ (void) removeSF_ProgressHUD {
    
    
    
//    [SF_LzdProgressTwoHUD dismissSFHUD];
//
//    // 同时移除SVProgressHUD,因为不知道哪还隐藏着这个
//    [SVProgressHUD dismiss];
}


// 加载百信sfHUD（不能交互的HUD）
+ (void) addSF_BaiXinProgressHUD {
    
//    [SF_BaiXinProgressHUD sharedHUD];
//    [SF_BaiXinProgressHUD showSFHUD];
}

// 移除百信sfHUD
+ (void) removeSF_BainXinProgressHUD {
    
//    [SF_BaiXinProgressHUD dismissSFHUD];
}




/*!
 两张图组合成一张图
 baseImage：底图
 qrCodeImage: 二维码图
 orgin:位置（x，y）
 */
+ (UIImage *) composeImgWithBaseImage:(UIImage *)baseImage qrCodeImage:(UIImage *)qrCode orgin:(CGPoint)orgin{
	
	UIImage *img = qrCode;
	CGImageRef imgRef = img.CGImage;
	CGFloat w = CGImageGetWidth(imgRef);
	CGFloat h = CGImageGetHeight(imgRef);
	
	//以1.png的图大小为底图
	UIImage *img1 = baseImage;
	CGImageRef imgRef1 = img1.CGImage;
	CGFloat w1 = CGImageGetWidth(imgRef1);
	CGFloat h1 = CGImageGetHeight(imgRef1);
	
	//以1.png的图大小为画布创建上下文
	UIGraphicsBeginImageContext(CGSizeMake(w1, h1));
	[img1 drawInRect:CGRectMake(0, 0, w1, h1)];//先把1.png 画到上下文中
	[img drawInRect:CGRectMake(orgin.x, orgin.y, w, h)];//再把小图放在上下文中
	UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
	UIGraphicsEndImageContext();//关闭上下文
	
	return resultImg;
}

/**
 *  二维码生成(Erica Sadun 原生代码生成)
 *
 *  @param string   内容字符串
 *  @param size 二维码大小
 *  @param color 二维码颜色
 *  @param backGroundColor 背景颜色
 *
 *  @return 返回一张图片
 */
//二维码生成
+ (UIImage *)qrImageWithString:(NSString *)string size:(CGSize)size color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor {
	CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
	if (!qrFilter)
	{
		NSLog(@"Error: Could not load filter");
		return nil;
	}
	
	[qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
	
	
	NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
	[qrFilter setValue:stringData forKey:@"inputMessage"];
	CIFilter * colorQRFilter = [CIFilter filterWithName:@"CIFalseColor"];
	[colorQRFilter setValue:qrFilter.outputImage forKey:@"inputImage"];
	//二维码颜色
	if (color == nil) {
		color = [UIColor blackColor];
	}
	if (backGroundColor == nil) {
		backGroundColor = [UIColor whiteColor];
	}
	[colorQRFilter setValue:[CIColor colorWithCGColor:color.CGColor] forKey:@"inputColor0"];
	//背景颜色
	[colorQRFilter setValue:[CIColor colorWithCGColor:backGroundColor.CGColor] forKey:@"inputColor1"];
	
	
	CIImage *outputImage = [colorQRFilter valueForKey:@"outputImage"];
	
	UIImage *smallImage = [self imageWithCIImage:outputImage orientation: UIImageOrientationUp];
	
	return [self resizeImageWithoutInterpolation:smallImage size:size];
}

/*! 获取当前时间与输入的时间差（天）当天算一天 */
+ (NSInteger)getNowDateWithDateDifference:(NSString *)date {
	//获得当前时间
	NSDate *now = [NSDate date];
	//实例化一个NSDateFormatter对象
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//设定时间格式
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *oldDate = [dateFormatter dateFromString:date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	unsigned int unitFlags = NSCalendarUnitDay;
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
	
	return [comps day] + 1;
}

/*! 获取输入两个时间的差值 单位：天 例如：2019-01-02  */
+ (NSInteger)getFirstDate:(NSString *)firstDate secondDate:(NSString *)secondDate {

	//实例化一个NSDateFormatter对象
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//设定时间格式
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *bigDate;
	NSDate *smallDate;
	if ([HQGeneralUtil compareStrCaseSensitiveWithFirstStr:firstDate secondStr:secondDate] == firstBig) {
		
		bigDate = [dateFormatter dateFromString:firstDate];
		smallDate = [dateFormatter dateFromString:secondDate];
	}else if ([HQGeneralUtil compareStrCaseSensitiveWithFirstStr:firstDate secondStr:secondDate] == firstSmall) {
		
		bigDate = [dateFormatter dateFromString:secondDate];
		smallDate = [dateFormatter dateFromString:firstDate];
	}else {
		
		return 0;
	}
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	unsigned int unitFlags = NSCalendarUnitDay;
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:smallDate  toDate:bigDate  options:0];
	return [comps day];
}


/*! 获取某个日期前N天的日期  */
+ (NSString *)getBeforeNDayDateWithDays:(NSInteger)days date:(NSString *)date {
	
	//实例化一个NSDateFormatter对象
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//设定时间格式
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *timeDate = [dateFormatter dateFromString:date];
	NSDate *theDate;
	if (days != 0) {
		
		NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
		
		theDate = [timeDate initWithTimeInterval:-oneDay*days sinceDate:timeDate];
		
		return [dateFormatter stringFromDate:theDate];
	}else {
		
		return date;
	}
}

/*! 获取某个日期后N天的日期  */
+ (NSString *)getAfterNDayDateWithDays:(NSInteger)days date:(NSString *)date {
	
	//实例化一个NSDateFormatter对象
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//设定时间格式
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *timeDate = [dateFormatter dateFromString:date];
	NSDate *theDate;
	if (days != 0) {
		
		NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
		
		theDate = [timeDate initWithTimeInterval:+oneDay*days sinceDate:timeDate];
		
		return [dateFormatter stringFromDate:theDate];
	}else {
		
		return date;
	}
}

///身份证号
+(BOOL) validateIdentityCard:(NSString *)value {
	value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSInteger length = 0;
	if (!value) {
		return NO;
	}else {
		length = value.length;
		//不满足15位和18位，即身份证错误
		if (length !=15 && length !=18) {
			return NO;
		}
	}
	 // 省份代码
	NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
	// 检测省份身份行政区代码
	NSString *valueStart2 = [value substringToIndex:2];
	BOOL areaFlag =NO; //标识省份代码是否正确
	for (NSString *areaCode in areasArray) {
		if ([areaCode isEqualToString:valueStart2]) {
			areaFlag =YES;
			break;
		}
	}
	
	if (!areaFlag) {
		return NO;
	}
	NSRegularExpression *regularExpression;
	NSUInteger numberofMatch;
	int year =0;
	//分为15位、18位身份证进行校验
	switch (length) {
		case 15:
		{
			//获取年份对应的数字
			year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
			
			if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
				
				//创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
				regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
				
			}else {
				
				regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
			}
			
			//使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
			numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
			if(numberofMatch >0) {
				return YES;
			}else {
				return NO;
			}
		}
			break;
		
		case 18:
		{
			year = [value substringWithRange:NSMakeRange(6,4)].intValue;
			if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
				
               regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
			}else {
				regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
			}
			numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
			if(numberofMatch >0) {
				//1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
				int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
				//2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
				int Y = S %11;
				NSString *M =@"F";
				NSString *JYM =@"10X98765432";
				M = [JYM substringWithRange:NSMakeRange(Y,1)];// 3：获取校验位
				NSString *lastStr = [value substringWithRange:NSMakeRange(17,1)];
				NSLog(@"%@",M);
				NSLog(@"%@",[value substringWithRange:NSMakeRange(17,1)]);
				//4：检测ID的校验位
				if ([lastStr isEqualToString:@"x"]) {
					if ([M isEqualToString:@"X"]) {
						return YES;
					}else{
						return NO;
					}
				}else{
					 if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
						return YES;
					 }else {
						 return NO;
					 }
					
				}
			}else {
				 return NO;
			}
		}
			break;
		default:
		return NO;
	}
}

/// 如果是是空，则返回空字符串
+ (NSString *)isEmptyRetunEmptyStr:(NSString *)str {
	
	if (KIsEmptyStr(str)) {
	
		return @"";
	}else {
		
		return str;
	}
}

/// 获取某个日期N个月前或后的数据  正数是前  负数是后
+ (NSString *)getPriousorLaterDateFromDate:(NSString *)date withMonth:(NSInteger)month {
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *dealTime = [formatter dateFromString:date];
	
	///
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	
	[comps setMonth:month];
	
	NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	
	NSDate *mDate = [calender dateByAddingComponents:comps toDate:dealTime options:0];
	
	///
	NSString *resultTimeString = [formatter stringFromDate:mDate];
	
	return [HQGeneralUtil getBeforeNDayDateWithDays:1 date:resultTimeString];
}

/// 获取系统版本
+ (NSString *) getPhoneSystemVersion {
    
    return [[UIDevice currentDevice] systemVersion];
}

/// 获取手机型号
+ (NSString *) getPhoneModel {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone3,1"]) {
        
        return@"iPhone 4";
    }
    
    if([platform isEqualToString:@"iPhone3,3"]) {
        
        return@"iPhone 4";
    }
    
    if([platform isEqualToString:@"iPhone4,1"]) {
        
        return@"iPhone 4S";
    }
    
    if([platform isEqualToString:@"iPhone5,1"]) {
        
        return@"iPhone 5";
    }
    
    if([platform isEqualToString:@"iPhone5,2"]) {
        
        return@"iPhone 5";
    }
    
    if([platform isEqualToString:@"iPhone5,3"]) {
        
        return@"iPhone 5c";
    }
    
    if([platform isEqualToString:@"iPhone5,4"]) {
        
        return@"iPhone 5c";
    }
    
    if([platform isEqualToString:@"iPhone6,1"]) {
        
        return@"iPhone 5s";
    }
    
    if([platform isEqualToString:@"iPhone6,2"]) {
        
        return@"iPhone 5s";
    }
    
    if([platform isEqualToString:@"iPhone7,1"]) {
        
        return@"iPhone 6 Plus";
    }
    
    if([platform isEqualToString:@"iPhone7,2"]) {
        
        return@"iPhone 6";
    }
    
    if([platform isEqualToString:@"iPhone8,1"]) {
        
        return@"iPhone 6s";
    }
    
    if([platform isEqualToString:@"iPhone8,2"]) {
        
        return@"iPhone 6s Plus";
    }
    if([platform isEqualToString:@"iPhone8,4"]) {
        
        return@"iPhone SE";
    }
    
    if([platform isEqualToString:@"iPhone9,1"]) {
        
        return@"iPhone 7";
    }
    
    if([platform isEqualToString:@"iPhone9,2"]) {
        
        return@"iPhone 7 Plus";
    }
    
    if([platform isEqualToString:@"iPhone10,1"]) {
        
        return@"iPhone 8";
    }
    
    if([platform isEqualToString:@"iPhone10,4"]) {
        
        return@"iPhone 8";
    }
    
    if([platform isEqualToString:@"iPhone10,2"]) {
        
        return@"iPhone 8 Plus";
    }
    
    if([platform isEqualToString:@"iPhone10,5"])  {
        
        return@"iPhone 8 Plus";
    }
    
    if([platform isEqualToString:@"iPhone10,3"])  {
        
        return@"iPhone X";
    }
    
    if([platform isEqualToString:@"iPhone10,6"])  {
        
        return@"iPhone X";
    }
    
    if ([platform isEqualToString:@"iPhone11,8"])   {
        
        return @"iPhone XR";
    }
    if ([platform isEqualToString:@"iPhone11,2"])   {
        
        return @"iPhone XS";
    }
    if ([platform isEqualToString:@"iPhone11,6"])   {
        
        return @"iPhone XS Max";
    }
    if ([platform isEqualToString:@"iPhone11,4"])   {
        
        return @"iPhone XS Max";
    }
    
    
    if([platform isEqualToString:@"i386"]) {
        
        return@"iPhone Simulator";
    }
    
    if([platform isEqualToString:@"x86_64"]) {
        
        return@"iPhone Simulator";
    }
    
    return @"未知型号";
}

/// 获取网络类型
+ (void) getNetworkingType:(void(^)(NSString *str))networkingTypeBlock {
    
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//
//    // 提示：要监控网络连接状态，必须要先调用单例的startMonitoring方法
//    [manager startMonitoring];
//
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//
//        if (status == -1) {
//
//            networkingTypeBlock(@"未知网络");
//        }
//        if (status == 0) {
//
//            networkingTypeBlock(@"未连接网络");
//        }
//        if (status == 1) {
//
//            networkingTypeBlock(@"流量");
//        }
//        if (status == 2) {
//
//            networkingTypeBlock(@"Wifi");
//        }
//    }];
}

/*!
 展示alertVC
 tag:0左侧按钮
 tag:1右侧按钮
 */
+ (void) showAlertVCWithTitle:(NSString *)title leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle vc:(UIViewController *)vc actionBlock:(void(^)(int tag))actionBlock {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    if (leftBtnTitle != nil) {
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:leftBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (actionBlock) {
                
                actionBlock(0);
            }
            
        }];
        
        [alertController addAction:cancleAction];
    }
    
    if (rightBtnTitle != nil) {
        
        UIAlertAction *pushAction = [UIAlertAction actionWithTitle:rightBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (actionBlock) {
                
                actionBlock(1);
            }
      
        }];
        
        [alertController addAction:pushAction];
    }
    
    [vc presentViewController:alertController animated:YES completion:nil];
}


/// tost提示
+ (void) showTostWithMessage:(NSString *)message duration:(double)duration {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [CSToastManager setQueueEnabled:NO];
        [[UIApplication sharedApplication].delegate.window makeToast:message duration:duration position:CSToastPositionCenter];
//        [SVProgressHUD showErrorWithStatus:message];
    });
    
}

/*!
 tost提示
 默认2秒
 */
+ (void) showTostWithMessage:(NSString *)message {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [CSToastManager setQueueEnabled:NO];
//        [SVProgressHUD showErrorWithStatus:message];
        [[UIApplication sharedApplication].delegate.window makeToast:message duration:2 position:CSToastPositionCenter];
    });
    
}


/*!
 成功tost提示
 默认2秒
 */
+ (void) showSuccessTostWithMessage:(NSString *)message {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [CSToastManager setQueueEnabled:NO];
//        [SVProgressHUD showSuccessWithStatus:message];
        [[UIApplication sharedApplication].delegate.window makeToast:message duration:2 position:CSToastPositionCenter];
    });
    
}
    
/*!
 获取app图标
 */
+ (UIImage *) getAppIcon {
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage *img = [UIImage imageNamed:icon];
    
    return img;
}

/// 设置状态栏颜色
+ (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

/// 裁剪图片
+ (UIImage *)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r
{
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    //CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);

    return img;
}


/// 根据url和参数生成链接地址，用于cache的key
+ (NSString *)urlParameterToStringWithUrlStr:(NSString *)urlStr WithDict:(NSDictionary *)parameters
{
    if (!parameters) {
        return urlStr;
    }
    NSMutableArray *parts = [NSMutableArray array];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if([key isKindOfClass:[NSString class]] && [obj isKindOfClass:[NSString class]]){
            NSString *finalKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSString *finalValue = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSString *part =[NSString stringWithFormat:@"%@=%@",finalKey,finalValue];
            
            [parts addObject:part];
        }
    }];
    NSString *queryString = [parts componentsJoinedByString:@"&"];
    queryString = queryString ? [NSString stringWithFormat:@"?%@",queryString] : @"";
    NSString *pathStr = [NSString stringWithFormat:@"%@?%@",urlStr,queryString];
    return pathStr;
}

/// 用户是否开通了通知权限
+ (void)userIsOpenNotificationPermissions:(void (^)(BOOL isOpen))isOpenPermissions {
    //首先判断应用通知是否授权，注意iOS10.0之后方法不一样
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined)
            {
                MHLog(@"未选择");
                isOpenPermissions(NO);
            }else if (settings.authorizationStatus == UNAuthorizationStatusDenied){
                MHLog(@"未授权");
                isOpenPermissions(NO);;
            }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                MHLog(@"已授权");
                isOpenPermissions(YES);
            }
        }];
    } else {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == 0) {
            
            isOpenPermissions(NO);
        }else {
            
            isOpenPermissions(YES);
        }
    }
}

/// 跳转开启通知开关页面
+ (void) jumpOpenNotificationPage {
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
/// 毛玻璃效果
+ (UIColor *)groundGlassEffectWithImage:(UIImage *)originImage {
    UIImage *image = originImage;
    if (!image) {
        return nil;
    }
    UIImage *blurImage = [self blurryImage:image withBlurLevel:0.5];
    return [UIColor colorWithPatternImage:blurImage];
}

/// 高斯模糊效果
+ (UIImage *)gaoSiMoHuEffectWithImage:(UIImage *)originImage {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:originImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputRadius"];
    
    //        CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CIImage *result=[filter outputImage];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return image;
}
/// 带有#的6位颜色值转换成UIColor
+ (UIColor *) colorStrChangeUIColor:(NSString *)colorStr {
    
    if (colorStr == nil) {
        
        return UIMainColor;
    }
    
    NSString *colorString = [[colorStr stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return nil;
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/// 获取设备UUID
+ (NSString *) getDeviceUUID {
    
    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; //获取设备唯一标识符 例如：FBF2306E-A0D8-4F4B-BDED-9333B627D3E6
    return deviceUUID;
}

#pragma mark ---私有方法---

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}
//根据字体获取自适应的宽度
+ (CGFloat)justWidthWithStr:(NSString *)str FontSize:(CGFloat)fontSize Limit:(CGFloat)height {
    CGSize constraint = CGSizeMake(20000.f, height);
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [str boundingRectWithSize:constraint options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.width;
}

+ (UIImage *)resizeImageWithoutInterpolation:(UIImage *)sourceImage size:(CGSize)size
{
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationNone);
	[sourceImage drawInRect:(CGRect){.size = size}];
	UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return result;
}

+ (UIImage *)imageWithCIImage:(CIImage *)aCIImage orientation: (UIImageOrientation)anOrientation
{
	if (!aCIImage) return nil;
	
	CGImageRef imageRef = [[CIContext contextWithOptions:nil] createCGImage:aCIImage fromRect:aCIImage.extent];
	UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:anOrientation];
	CFRelease(imageRef);
	
	return image;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    //根据圆角路径绘制
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

 + (CGFloat)getStatusBarHight {
    float statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    }
    else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}
                                                   
@end
