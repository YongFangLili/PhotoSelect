//
//  LBPhotoPickerController.m
//  LBPhotoPicker
//
//  Created by 李永方 on 2017/5/21.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import "LBPhotoPickerController.h"
#import "LBPhotoPickerViewCell.h"
#import "LBPhotoSelectTipModel.h"

/// 屏幕宽高.
#define PHONE_WIDTH         [[UIScreen mainScreen] bounds].size.width
#define PHONE_HEIGHT        [[UIScreen mainScreen] bounds].size.height

static NSString *kPhotoPickerCellID = @"kPhotoPickerCellID";

@interface LBPhotoPickerController ()
<
UICollectionViewDataSource,
LBPhotoPickerViewCellDelegete,
UICollectionViewDelegate
>


/* 图片列表 **/
@property (nonatomic, strong) UICollectionView *photoCollectionView;

@end

@implementation LBPhotoPickerController

#pragma mark -lifeCycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.photoCollectionView];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    LBPhotoPickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoPickerCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)didClickSelectButton:(UIButton *)button {
    
    // 处理button 按钮
    
    button.selected = !button.selected;
    for (int i = 0; i < self.upLoadTipArray.count; i ++) {
        if (button.selected) {
            // 遍历未被选中的
            LBPhotoSelectTipModel *tipModel = self.upLoadTipArray[i];
            if (!tipModel.isSelected) {
                tipModel.isSelected = YES;
                [button setTitle:[NSString stringWithFormat:@"%zd",tipModel.upLoadIndex] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor redColor];
                break;
            }else {
                
                // 找到序号一样并且没有被选中的
                if ([button.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%zd",tipModel.upLoadIndex]]) {
                    tipModel.isSelected = NO;
                    [button setTitle:@""forState:UIControlStateNormal];
                    button.backgroundColor = [UIColor grayColor];
                }
            
            }
           
        }
    }
    
    
    // 处理提示信息


}

#pragma mark -lazy
-(NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UICollectionView *)photoCollectionView {
    
    if (!_photoCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection  = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.itemSize = CGSizeMake((PHONE_WIDTH - 3)/4, (PHONE_WIDTH - 3)/4);
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64, PHONE_WIDTH, PHONE_HEIGHT - 64) collectionViewLayout:flowLayout];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.backgroundColor = [UIColor whiteColor];
        [_photoCollectionView registerClass:[LBPhotoPickerViewCell class] forCellWithReuseIdentifier:kPhotoPickerCellID];
    }
    return _photoCollectionView;
}

- (NSMutableArray *)upLoadTipArray {
    
    if (!_upLoadTipArray) {
        _upLoadTipArray = [NSMutableArray array];
    }
    return _upLoadTipArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
