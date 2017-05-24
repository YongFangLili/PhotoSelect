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

/** 下一步按钮 */
@property (nonatomic, strong) UIButton *nextTipBtn;
/** 提示label */
@property (nonatomic, strong) UILabel *tipLble;

@property (nonatomic, strong) LBPhotoSelectTipModel *nextTipModel;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation LBPhotoPickerController

#pragma mark -lifeCycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.photoCollectionView];
    [self.view addSubview:self.tipLble];
    [self.view addSubview:self.nextTipBtn];
    
    self.tipLble.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height - 60 - 40 , [UIScreen mainScreen].bounds.size.width, 40);
    self.nextTipBtn.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height -10 - 30 , [UIScreen mainScreen].bounds.size.width - 40, 30);
    self.photoCollectionView.frame = CGRectMake(0, 64, PHONE_WIDTH,CGRectGetMinY(self.tipLble.frame) - 64);
    [self updateTipText];
    
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

- (void)didClickSelectButton:(UIButton *)button model:(LBPhotoPickerModel *)model{
    
//    // 处理button 按钮
    button.selected = !button.selected;
//    if (button.selected) { // 选中了，选择图片
//        self.nextTipModel.isSelected = YES;
//        model.selected = YES;
//        model.upLoadIndex = self.nextTipModel.upLoadIndex;
//        [button setTitle:[NSString stringWithFormat:@"%zd",self.nextTipModel.upLoadIndex] forState:UIControlStateNormal];
//        button.backgroundColor = [UIColor redColor];
//        [self.selectedArray addObject:self.nextTipModel];
//    }else { // 取消选中
//        
//        model.selected = NO;
//        model.upLoadIndex =
//        
//        
//        
//        
//    
//    }
    
    for (int i = 0; i < self.upLoadTipArray.count; i ++) {
        
        LBPhotoSelectTipModel *tipModel = self.upLoadTipArray[i];
        if (button.selected) {
            // 遍历未被选中的
            if (!tipModel.isSelected) {
                tipModel.isSelected = YES;
                [button setTitle:[NSString stringWithFormat:@"%zd",tipModel.upLoadIndex] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor redColor];
                model.selected = YES;
                model.upLoadIndex = tipModel.upLoadIndex;
                [self.selectedArray addObject:model];
                // 刷新一下显示
                [self updateTipText];
                break;
            }
        }else {
            
            // 找到序号一样并且没有被选中的
            if ([button.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%zd",tipModel.upLoadIndex]]) {
                tipModel.isSelected = NO;
                model.upLoadIndex = tipModel.upLoadIndex;
                if (self.selectedArray.count > 0 && [self.selectedArray containsObject:model]) {
                    [self.selectedArray removeObject:model];
                }
                [button setTitle:@""forState:UIControlStateNormal];
                button.backgroundColor = [UIColor grayColor];
                // 刷新一下显示
                [self updateTipText];
                break;
            }
        }
    }
    // 处理提示信息
}

- (void)updateTipText {
    
    if (self.upLoadTipArray.count > 0) {
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
                [self.nextTipBtn setTitle:[NSString stringWithFormat:@"下一步(%zd/%zd)",self.selectedArray.count,self.upLoadTipArray.count] forState:UIControlStateNormal];
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


@end
