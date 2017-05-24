//
//  LBPhotoSelectTipModel.h
//  LBPhotoPicker
//
//  Created by liyongfang on 2017/5/23.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBPhotoSelectTipModel : NSObject

/** 上传的顺序 */
@property (nonatomic, assign) NSInteger upLoadIndex;

/** 上传的文字提示 */
@property (nonatomic, copy) NSString *tipText;

/** 是否已经选中 */
@property (nonatomic, assign) BOOL isSelected;



@end
