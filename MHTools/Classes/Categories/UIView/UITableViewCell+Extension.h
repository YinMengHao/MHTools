//
//  UITableViewCell+Extension.h
//  suixingyoutarget
//
//  Created by HelloWorld on 2020/5/11.
//  Copyright © 2020 suixingyou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (Extension)
- (void)configureTableViewCellWithModel:(id)model;
- (void)configureTableViewCellWithModel:(id)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
