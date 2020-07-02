//
//  UICollectionViewCell+Extension.h
//  suixingyoutarget
//
//  Created by HelloWorld on 2020/5/12.
//  Copyright © 2020 suixingyou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (Extension)
- (void)configureCollectionCellWithModel:(id)model;
- (void)configureCollectionCellWithModel:(id)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
