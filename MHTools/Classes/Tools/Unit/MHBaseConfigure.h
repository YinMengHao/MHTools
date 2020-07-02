//
//  MHBaseConfigure.h
//  suixingyoutarget
//
//  Created by HelloWorld on 2020/5/6.
//  Copyright © 2020 suixingyou. All rights reserved.
//

#ifndef MHBaseConfigure_h
#define MHBaseConfigure_h

#import "UIColor+Hex.h"
#import "UIImage+Extention.h"
#import "MHCreateViewTool.h"
#import "UIButton+MHExtension.h"
#import "NSString+NSStringUtil.h"
#import "HQGeneralUtil.h"
#import "UITableViewCell+Extension.h"
#import "UICollectionViewCell+Extension.h"
//#import <Masonry/Masonry.h>



/*************************判断是否为空******************************/
/// 针对于字符串的
#define KIsEmptyStr(str) (str == nil || [str isEqual:[NSNull null]] || [str isEqual:[NSNull class]] || [str isEqualToString:@""])

/// 判断是不是空nil（针对于id类型）
#define KIsEmptyNil(str) (str == nil || [str isEqual:[NSNull null]] || [str isEqual:[NSNull class]])


/**************************颜色*****************************/
// RGBA颜色处理
#define UIColorFromRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
/*************************颜色******************************/
#define UIMainColor UIColorFromRGBAHEX(0x04CBB1)
// RGBA_十六进制颜色处理
#define UIColorFromRGBAHEX(rgbaHex) [UIColor colorWithRed:((float)((rgbaHex & 0xFF0000) >> 16))/255.0 green:((float)((rgbaHex & 0xFF00) >> 8))/255.0 blue:((float)(rgbaHex & 0xFF))/255.0 alpha:1.0]

/*************************引用转换******************************/
#define WS(weakSelf)    __weak __typeof(&*self) weakSelf = self

//自定义Log打印
#ifdef DEBUG //开发阶段
#define MHLog(...) NSLog(__VA_ARGS__)
#else//发布阶段
#define MHLog(...)
#endif
#endif /* MHBaseConfigure_h */
