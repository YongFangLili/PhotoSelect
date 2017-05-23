//
//  LBPhotoPickerViewCell.h
//  LBPhotoPicker
//
//  Created by liyongfang on 2017/5/23.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPhotoPickerModel.h"

@protocol LBPhotoPickerViewCellDelegete <NSObject>

/**
 * @brief 点击选中按钮状态
 */
- (void)didClickSelectButton:(UIButton *)button;

@end

@interface LBPhotoPickerViewCell : UICollectionViewCell

/** 模型 */
@property (nonatomic, strong)LBPhotoPickerModel *model;
/** 代理 */
@property (nonatomic, weak)id<LBPhotoPickerViewCellDelegete>delegate;

@end
