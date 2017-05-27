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
#import "LBPhotoPickerDetailController.h"

/// 屏幕宽高.
#define PHONE_WIDTH         [[UIScreen mainScreen] bounds].size.width
#define PHONE_HEIGHT        [[UIScreen mainScreen] bounds].size.height

static NSString *kPhotoPickerCellID = @"kPhotoPickerCellID";

@interface LBPhotoPickerController ()
<
UICollectionViewDataSource,
LBPhotoPickerViewCellDelegete,
UICollectionViewDelegate,
LBPhotoPickerDetailControllerDelegate
>


/* 图片列表 **/
@property (nonatomic, strong) UICollectionView *photoCollectionView;
/** 下一步按钮 */
@property (nonatomic, strong) UIButton *nextTipBtn;
/** 提示label */
@property (nonatomic, strong) UILabel *tipLble;

@property (nonatomic, strong) LBPhotoSelectTipModel *nextTipModel;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, strong) NSMutableArray *photArray;

@end

@implementation LBPhotoPickerController

#pragma mark -lifeCycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initPhotoData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.photoCollectionView];
    [self.view addSubview:self.tipLble];
    [self.view addSubview:self.nextTipBtn];
    
    self.tipLble.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height - 60 - 40 , [UIScreen mainScreen].bounds.size.width, 40);
    self.nextTipBtn.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height -10 - 30 , [UIScreen mainScreen].bounds.size.width - 40, 30);
    self.photoCollectionView.frame = CGRectMake(0, 64, PHONE_WIDTH,CGRectGetMinY(self.tipLble.frame) - 64);
    // 解析数据
   
    [self updateTipText];
    
}

- (void)initPhotoData{
    
    for (int i = 0 ; i < self.dataArray.count; i++) {
        PHAsset * asset = (PHAsset *)self.dataArray[i];
        LBPhotoPickerModel *model = [[LBPhotoPickerModel alloc] init];
        model.PHAsset = asset;
        [self.photArray addObject:model];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    LBPhotoPickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoPickerCellID forIndexPath:indexPath];
    cell.model = self.photArray[indexPath.row];
    cell.cellIndex = indexPath.row;
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获取图片
    LBPhotoPickerDetailController *detailVC = [[LBPhotoPickerDetailController alloc] init];
    detailVC.photoArray = self.photArray;
    detailVC.currentIndex = indexPath.row;
    detailVC.selectedArray = self.selectedArray;
    detailVC.upLoadTipArray = self.upLoadTipArray;
    detailVC.delegate = self;
    [self.navigationController pushViewController:detailVC animated:YES];
}

// 刷新显示数据
- (void)didClickSelectPhotoButtonWithCurrentIndex:(NSInteger)currentIndex {
    
//    // 取当前的cell
//    if (self.selectedArray.count >= self.upLoadTipArray.count) {
//        return;
//    }
//    LBPhotoPickerViewCell *cell = [self.photoCollectionView dequeueReusableCellWithReuseIdentifier:kPhotoPickerCellID forIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
//    cell.model = self.photArray[currentIndex];
//    [self.photoCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:currentIndex inSection:0]]];
//    [self updateTipText];
    [self didClickSelectButtonWithcellIndex:currentIndex];

}

- (void)refreshDataWithCurrentIndex:(NSInteger)currentIndex {
    
    // 取当前的cell
    if (self.selectedArray.count >= self.upLoadTipArray.count) {
        return;
    }
    LBPhotoPickerViewCell *cell = [self.photoCollectionView dequeueReusableCellWithReuseIdentifier:kPhotoPickerCellID forIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    cell.model = self.photArray[currentIndex];
    
    [self.photoCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:currentIndex inSection:0]]];
    [self updateTipText];

}

- (void)didClickSelectButtonWithcellIndex:(NSInteger)index {
    
    // 防止越界
    if ((self.photArray.count -1 ) < index && self.photArray.count == 0) {
        return;
    }
    LBPhotoPickerModel *model = self.photArray[index];
    for (int i = 0; i < self.upLoadTipArray.count; i++) {
        
        LBPhotoSelectTipModel *tipModel = self.upLoadTipArray[i];
        if (!model.selected) {
            // 遍历未被选中的
            if (!tipModel.isSelected) {
                tipModel.isSelected = YES;
                model.selected = YES;
                model.upLoadIndex = tipModel.upLoadIndex;
                [self.selectedArray addObject:model];
                [self refreshDataWithCurrentIndex:index];
                break;
            }
        }else {
            // 找到序号一样并且没有被选中的
            if (model.upLoadIndex == tipModel.upLoadIndex) {
                tipModel.isSelected = NO;
                model.upLoadIndex = tipModel.upLoadIndex;
                model.selected = NO;
                if (self.selectedArray.count > 0 && [self.selectedArray containsObject:model]) {
                    [self.selectedArray removeObject:model];
                    [self refreshDataWithCurrentIndex:index];
                    break;
                }
            }
        }
    }
    // 处理提示信息
}

// 更新上传提示信息
- (void)updateTipText {
    
    if (self.upLoadTipArray.count > 0) {
        
         [self.nextTipBtn setTitle:[NSString stringWithFormat:@"下一步(%zd/%zd)",self.selectedArray.count ,self.upLoadTipArray.count] forState:UIControlStateNormal];
        
        for (int i = 0; i < self.upLoadTipArray.count; i++ ) {
            
            LBPhotoSelectTipModel *tipMode = self.upLoadTipArray [i];
            
            if (tipMode.isSelected == NO) {
                self.nextTipModel = tipMode;
                self.tipLble.text = [NSString stringWithFormat:@"请选择%@",tipMode.tipText];
                if (self.selectedArray.count == 0) {
                    self.nextTipBtn.enabled = NO;
                }else{
                    self.nextTipBtn.enabled = YES;
                }
                break;
                
            }
        }
    }
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

- (UIButton *)nextTipBtn {
    
    if (!_nextTipBtn) {
        _nextTipBtn = [[UIButton alloc] init];
        _nextTipBtn.backgroundColor = [UIColor redColor];
        
    }
    return _nextTipBtn;
}

- (UILabel *)tipLble {
    
    if (!_tipLble) {
        _tipLble = [[UILabel alloc] init];
        _tipLble.backgroundColor = [UIColor grayColor];
    }
    return _tipLble;
}


- (NSMutableArray *)upLoadTipArray {
    
    if (!_upLoadTipArray) {
        _upLoadTipArray = [NSMutableArray array];
    }
    return _upLoadTipArray;
}

- (NSMutableArray *)selectedArray {
    
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)photArray {
    
    if (!_photArray) {
        _photArray = [NSMutableArray array];
    }
    return _photArray;
}


@end
