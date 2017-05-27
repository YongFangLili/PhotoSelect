//
//  LBPhotoPickerDetailController.h
//  LBPhotoPicker
//
//  Created by liyongfang on 2017/5/26.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBPhotoPickerDetailControllerDelegate <NSObject>

- (void)didClickSelectPhotoButtonWithCurrentIndex:(NSInteger)currentIndex;

@end
@interface LBPhotoPickerDetailController : UIViewController

/** 选中的Index */
@property (nonatomic, assign) NSInteger currentIndex;

/** 照片array */
@property (nonatomic, strong) NSMutableArray *photoArray;

/** 上传提示数组  这部分需要外界控制*/
@property (nonatomic, strong) NSMutableArray *upLoadTipArray;
/** 选中array */
@property (nonatomic, strong) NSMutableArray *selectedArray;
/** 代理 */
@property (nonatomic, weak) id <LBPhotoPickerDetailControllerDelegate>delegate;


@end
