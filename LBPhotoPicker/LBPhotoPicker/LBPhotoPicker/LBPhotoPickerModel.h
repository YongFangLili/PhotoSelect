//
//  LBPhotoPickerModel.h
//  LBPhotoPicker
//
//  Created by 李永方 on 2017/5/21.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface LBPhotoPickerModel : NSObject 

/** PHAsset*/
@property (nonatomic, strong) PHAsset * PHAsset;

/* 相册名称**/
@property (nonatomic,strong) NSString *albumName;

/** 缩略图 */
@property (nonatomic, strong) UIImage *thumail;
/** 原图 */
@property (nonatomic, strong) UIImage *originalImage;

/** 是否选中 */
@property (nonatomic, assign) BOOL selected;

/** 长传的 index */
@property (nonatomic, assign) NSInteger upLoadIndex;

@end
