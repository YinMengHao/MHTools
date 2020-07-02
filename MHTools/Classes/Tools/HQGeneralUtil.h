//
//  HQGeneralUtil.h
//  ODispatch
//
//  Created by 石峰 on 2017/2/13.
//  Copyright © 2017年 MengoTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

/*! wifi信息的类型枚举 */
typedef enum : NSUInteger {
    wifiName = 1,
    wifiMacAddress,
} WifiInfoType;

/*! 字符串比较大小结果类型枚举 */
typedef enum : NSUInteger {
    firstBig = 1,
    firstSmall,
    firstEqualSecond,
} StrCompareType;

/*! 绘制虚线的方向 */
typedef enum : NSUInteger {
	crossType = 1,
	verticalType,
} LineDirectionType;


@interface HQGeneralUtil : NSObject


/** 获取当前手机时间yyyy-MM-dd HH:mm:ss */
+ (NSString *)getCurrentPhoneTime;

/** 获取当前手机时间(yyyy-MM-dd) */
+ (NSString *)getCurrentPhoneTime1;

/** 获取时间 fotmatter是时间格式例如：(yyyy-MM-dd) */
+ (NSString *)getDateWithFormat:(NSString *)fotmatter;

/** 将传入的时间转成对应的格式 fotmatter是时间格式例如：(YYYY-MM-dd)（需要转的格式） */
+ (NSString *)getDateWithFormat:(NSString *)fotmatter date:(NSString *)date;

/** 获取一个随机数*/
+ (NSString *)getRandomNumbStr;

/** 获取wifi名称（真机有效）*/
+ (NSString *)getCurrentWifiSSID;

/** 获取当前版本号*/
+ (NSString *)getCurrentVersion;

/** 计算两点距离*/
+ (double)getDistanceBetween2Points:(CGPoint)firstP otherPoint:(CGPoint)secondP;

/** 检测手机号合法性*/
+ (BOOL)isLegalPhoneNumber:(NSString *)numberStr;

/** 判断纯数字（包括浮点型）*/
+ (BOOL)isPureInt:(NSString *)str;

/** 播放开锁声音*/
+ (void)playSoundIsScuess:(BOOL)success;

/** md5加密*/
+ (NSString *)md5Encryption:(NSString *)orignalStr;

/** 计算两点距离 (单位为米) */
+ (double)distanceBetweenCor1:(CLLocationCoordinate2D)cor1 Cor2:(CLLocationCoordinate2D)cor2;

/** 时间戳转年月日*/
+ (NSString *)timeStrTransformToDateStr:(NSString *)timeStr;

/// 根据指定date获取对应时间戳(精确到秒)  YY_添加
+ (NSTimeInterval)getTimestampSecondPrecisionWithDate:(NSDate *)date;

/// 计算给定时间与当前时间的距离  YY_添加
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime;


/*!
 计算给定时间与当前时间的距离  SF_添加
 beTime 为传入的时间戳
 */
+ (NSString *)sf_distanceTimeWithBeforeTime:(NSString *)beTimeStamp;


#pragma mark ---------------------获取文字首字母-----------------
//获取字符串首字母(传入汉字字符串, 返回大写拼音首字母，如果传入的是空，返回K)
+ (NSString *)getFirstLetterFromString:(NSString *)aString;



//-------------------------------二维码、条形码生成------------------------------

/** 生成条形码 BarCode */
+ (UIImage *)createBarCodeImageWithInfo:(NSString *)infoStr size:(CGSize)size;

/** 生成二维码 QRCode */
+ (UIImage *)createQRCodeImageWithInfo:(NSString *)infoStr size:(CGSize)size;


//-------------------------------七牛相关------------------------------

/** 获取七牛 图片名*/
+ (NSString *)getQiNiuImageName;

/** 获取七牛 语音文件名*/
+ (NSString *)getQiNiuAudioFileName;


//-------------------------------类型修正------------------------------
/** 修复dic arr 中为Null 的情况*/
+ (void)amendDicValueIsNSString:(NSMutableDictionary *)dic;
+ (void)amendArrValueIsNSString:(NSMutableArray *)arr;

/** 字符串转Dic*/
+ (NSDictionary *)amendDicStrToDic:(NSString *)dicStr;


//-------------------------------类型检测------------------------------
/** 检测dic中类型是否为NSString*/
+ (void)checkDicValueIsNSString:(NSDictionary *)dic;
/** 检测arr中类型是否为NSString*/
+ (void)checkArrValueIsNSString:(NSArray *)arr;

/*! 将字符传转换成富文本 */
+(NSAttributedString *)fillDZNEmptyDataSetwithTitle:(NSString *)title textColor:(UIColor *)color;

/*! 获取字符串中的的数字（整数） */
+ (NSString *)getPureDigitalFromStr:(NSString *)str;

/*! 获取字符串中的的数字（浮点数） */
+ (NSString *)getPureDigitalFloatFromStr:(NSString *)str;


/**
 * 图片压缩到指定大小
 * @param targetSize 目标图片的大小
 * @param sourceImage 源图片
 * @return 目标图片
 */
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage;

/*! 字典转json字符串方法 */ 
+ (NSString *)dicToJsonData:(NSDictionary *)dict;

/*！ JSON转字典 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/*! 替换返回的对象中有为nil的字段  */
+ (id)replaceNilForObject:(id)object;

/*! 汉字转拼音 */
+ (NSString *)chinesetransformPinYin:(NSString *)chinese;

/*! 空字符串返回 @“” */
+ (NSString *)returnEmptyStr:(NSString *)str;


/*! 空字符串返回-- */
+ (NSString *)returnLineStr:(NSString *)str;

/*! 判断字符串中是否有非法字符 */
+ (BOOL)isHaveIllegalCharacter:(NSString *)str;

/*!  获取当前控制器 */
+ (UIViewController *)currentViewController;


/*! 判断是否开启了定位 */
+ (BOOL)judgeLocationServiceEnabled;


/*! 获取IOS的IDFA（广告表示符，用于广告提供商追踪用户而设置的）
 
 广告标示符，适用于对外：例如广告推广，换量等跨应用的用户追踪等。但如果用户完全重置系统（(设置程序 -> 通用 -> 还原 -> 还原位置与隐私) ，这个广告标示符会重新生成。另外如果用户明确的还原广告(设置程序-> 通用 -> 关于本机 -> 广告 -> 还原广告标示符) ，那么广告标示符也会重新生成。注意：如果程序在后台运行，此时用户“还原广告标示符”，然后再回到程序中，此时获取广 告标示符并不会立即获得还原后的标示符。必须要终止程序，然后再重新启动程序，才能获得还原后的广告标示符。在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在 设置 -> 隐私 -> 广告追踪 里重置此id的值，或限制此id的使用。
 
 ios设备真正的唯一标识符UDID已经被禁用[[UIDevice currentDevice] uniqueIdentifier]（ios7已经完全废弃）
 */
+ (NSString *)getDeviceId;


/*! 获取wifi的mac地址 */
+ (NSString *)getWifiMacAddress:(WifiInfoType)wifiInfoType;

/*! 字符串比较大小区分大小写 */
+ (StrCompareType)compareStrCaseSensitiveWithFirstStr:(NSString *)firstStr secondStr:(NSString *)secondStr;

/*! 字符串比较大小不区分大小写 */
+ (StrCompareType)compareStrNoCaseSensitiveWithFirstStr:(NSString *)firstStr secondStr:(NSString *)secondStr;

//判断WIFI是否打开
+ (BOOL) isWiFiEnabled;

/*!
 为图片添加水印
 icon_mask:水印图
 icon_char：水印文字
 mask：原图
 charSize：水印文字大小
 */
+ (UIImage *)imageWithWaterImg:(UIImage*)icon_mask WaterChar:(NSString *)icon_char originImg:(UIImage*)mask icon_charSize:(CGFloat)charSize;

/*! 获取启动图 */
+ (UIImage *)launchImage;

/*!
 传入字符串数字，将字符串转换成每隔3位加上分隔符逗号的数字
 number:传入的字符串
 digit：需要保留的位数
 */
+ (NSString *)separateNumberUseCommaWith:(NSString *)number keepDecimalDigits:(NSUInteger)digit;

/*!
 返回虚线横着image的方法
 everyLineLength:线条每一小截的宽度
 widthOrHeight:如果是横线则是线条的高度，如果是竖线则是线条的宽度
 lineColor:线条颜色
 lineHeadType:线条的头部样式
 lineDirectionType:线条的方向
 drawLineByImageView
 */
+ (UIImage *)drawCrossTypeLineByImageView:(UIImageView *)imageView everyLineLength:(CGFloat)length widthOrHeight:(CGFloat)widthOrHeight lineColor:(UIColor *)color lineHeadType:(CGLineCap)lineHeadType;

/*!
 返回虚线竖直image的方法
 everyLineLength:线条每一小截的宽度
 widthOrHeight:如果是横线则是线条的高度，如果是竖线则是线条的宽度
 lineColor:线条颜色
 lineHeadType:线条的头部样式
 lineDirectionType:线条的方向
 */
+ (UIImage *)drawVerticalTypeLineByImageView:(UIImageView *)imageView everyLineLength:(CGFloat)length widthOrHeight:(CGFloat)widthOrHeight lineColor:(UIColor *)color lineHeadType:(CGLineCap)lineHeadType;

/*!
 日期转星期
 例如:2019-01-28
 */
+ (NSString*)getWeekDay:(NSString*)currentStr;

/*!
 
 获取某年某月的天数（例如2018-09）
 */
+ (NSString *)getNumberOfDaysInMonth:(NSString *)date;

///  是否安装支付宝
+ (BOOL) isInstallAlipy;

/// 加载（能交互的HUD）
+ (void) addSF_ProgressHUD;

// 加载sfHUD（不能交互的HUD）
+ (void) addSF_ProgressHUD:(BOOL)isUserInteraction;

/// 移除HUD
+ (void) removeSF_ProgressHUD;

/// 加载百信sfHUD（不能交互的HUD）
+ (void) addSF_BaiXinProgressHUD;


/// 移除百信sfHUD
+ (void) removeSF_BainXinProgressHUD;

/*!
 两张图组合成一张图
 baseImage：底图
 qrCodeImage: 二维码图
 orgin:位置（x，y）
 */
+ (UIImage *) composeImgWithBaseImage:(UIImage *)baseImage qrCodeImage:(UIImage *)qrCode orgin:(CGPoint)orgin;

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
+ (UIImage *)qrImageWithString:(NSString *)string size:(CGSize)size color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor;

/*! 获取当前时间与输入的时间差（天） */
+ (NSInteger)getNowDateWithDateDifference:(NSString *)date;

/*! 获取输入两个时间的差值 单位：天 例如：2019-01-02  */
+ (NSInteger)getFirstDate:(NSString *)firstDate secondDate:(NSString *)secondDate;

/*! 获取某个日期前N天的日期  */
+ (NSString *)getBeforeNDayDateWithDays:(NSInteger)days date:(NSString *)date;

/*! 获取某个日期后N天的日期  */
+ (NSString *)getAfterNDayDateWithDays:(NSInteger)days date:(NSString *)date;

///身份证号
+(BOOL) validateIdentityCard:(NSString *)value;

/// 如果是是空，则返回空字符串
+ (NSString *)isEmptyRetunEmptyStr:(NSString *)str;

/// 获取某个日期N个月前或后的数据  正数是前  负数是后
+ (NSString *)getPriousorLaterDateFromDate:(NSString *)date withMonth:(NSInteger)month;

/// 获取系统版本
+ (NSString *) getPhoneSystemVersion;

/// 获取手机型号
+ (NSString *) getPhoneModel;

/// 获取网络类型
+ (void) getNetworkingType:(void(^)(NSString *str))networkingTypeBlock;

/*!
 展示alertVC
 tag:0左侧按钮
 tag:1右侧按钮
 */
+ (void) showAlertVCWithTitle:(NSString *)title leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle vc:(UIViewController *)vc actionBlock:(void(^)(int tag))actionBlock;



/*!
 tost提示
 */
+ (void) showTostWithMessage:(NSString *)message duration:(double)duration;

/*!
 tost提示
 默认2秒
 */
+ (void) showTostWithMessage:(NSString *)message;

/*!
 成功tost提示
 默认2秒
 */
+ (void) showSuccessTostWithMessage:(NSString *)message;


/*!
 获取app图标
 */
+ (UIImage *) getAppIcon;

/// 设置状态栏颜色
+ (void)setStatusBarBackgroundColor:(UIColor *)color;

/// 裁剪图片
+ (UIImage *)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

/// 根据url和参数生成链接地址，用于cache的key
+ (NSString *)urlParameterToStringWithUrlStr:(NSString *)urlStr WithDict:(NSDictionary *)parameters;

/// 用户是否开通了通知权限
+ (void)userIsOpenNotificationPermissions:(void (^)(BOOL isOpen))isOpenPermissions;

/// 跳转开启通知开关页面
+ (void) jumpOpenNotificationPage;

/// 毛玻璃效果
+ (UIColor *)groundGlassEffectWithImage:(UIImage *)originImage;

/// 高斯模糊效果
+ (UIImage *)gaoSiMoHuEffectWithImage:(UIImage *)originImage;

/// 带有#的6位颜色值转换成UIColor
+ (UIColor *) colorStrChangeUIColor:(NSString *)colorStr;

/// 获取设备UUID
+ (NSString *) getDeviceUUID;

//获取导航栏高度
+ (CGFloat)getStatusBarHight;
@end















