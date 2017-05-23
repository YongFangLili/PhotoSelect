//
//  LBPhotoListViewController.h
//  LBPhotoPicker
//
//  Created by 李永方 on 2017/5/21.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBPhotoListViewController : UIViewController

/* 相册数组 **/
@property (nonatomic, strong) NSMutableArray *photoArray;

/** 上传提示数组  这部分需要外界控制*/
@property (nonatomic, strong) NSMutableArray *upLoadTipArray;



@end
