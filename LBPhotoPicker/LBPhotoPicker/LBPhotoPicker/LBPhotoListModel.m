//
//  LBPhotoListModel.m
//  LBPhotoPicker
//
//  Created by 李永方 on 2017/5/21.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import "LBPhotoListModel.h"

@implementation LBPhotoListModel


- (NSMutableArray *)photoArray {
    
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    
    return _photoArray;
}



@end
