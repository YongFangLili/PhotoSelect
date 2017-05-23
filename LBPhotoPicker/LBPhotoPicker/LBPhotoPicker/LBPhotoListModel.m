//
//  LBPhotoListModel.m
//  LBPhotoPicker
//
//  Created by 李永方 on 2017/5/21.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import "LBPhotoListModel.h"

@implementation LBPhotoListModel


- (NSMutableArray *)photoPickerArray {
    
    if (!_photoPickerArray) {
        _photoPickerArray = [NSMutableArray array];
    }
    
    return _photoPickerArray;
}

- (NSMutableArray *)upLoadTipArray {
    
    if (!_upLoadTipArray) {
        _upLoadTipArray = [NSMutableArray array];
    }
    return _upLoadTipArray;
}


@end
