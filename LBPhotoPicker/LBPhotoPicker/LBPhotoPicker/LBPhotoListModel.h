//
//  LBPhotoListModel.h
//  LBPhotoPicker
//
//  Created by 李永方 on 2017/5/21.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LBPhotoListModel : NSObject

/** 相册名字 */
@property (nonatomic, copy) NSString * albumName;
/** 类型 */
@property (nonatomic, copy) NSString * assetCollectionSubtype;
/** 封面图 */
@property (nonatomic, strong) UIImage * coverImage;
/** 图片数量*/
@property (nonatomic, copy) NSString *pictureNumber;
/** 是否选中*/
@property (nonatomic, assign) BOOL hasSelected;

@property (nonatomic, strong) NSMutableArray *photoArray;

@end
