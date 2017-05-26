//
//  LBPhotoPickerDetailController.m
//  LBPhotoPicker
//
//  Created by liyongfang on 2017/5/26.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import "LBPhotoPickerDetailController.h"
#import "LBphotoDetailCell.h"
/// 屏幕宽高.
#define PHONE_WIDTH         [[UIScreen mainScreen] bounds].size.width
#define PHONE_HEIGHT        [[UIScreen mainScreen] bounds].size.height
#define kCollectionViewHeight (PHONE_HEIGHT - 64 - 60)
static  NSString *kPhotoDetailCellIdentifier = @"kPhotoDetailCellIdentifier";

@interface LBPhotoPickerDetailController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic, strong) UICollectionView *photoDetailCollectionView;

/** 下一步按钮 */
@property (nonatomic, strong) UIButton *nextTipBtn;
/** 提示label */
@property (nonatomic, strong) UILabel *tipLble;

@end

@implementation LBPhotoPickerDetailController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpView];

}


- (void)setUpView {
    
    [self.view addSubview:self.photoDetailCollectionView];
    [self.view addSubview:self.tipLble];
    [self.view addSubview:self.nextTipBtn];
    
    self.photoDetailCollectionView.frame = CGRectMake(0, 64, PHONE_WIDTH, kCollectionViewHeight);
    self.tipLble.frame = CGRectMake(0, PHONE_HEIGHT - 60 - 5 - 36, PHONE_WIDTH, 36);
    self.nextTipBtn.frame = CGRectMake(9, PHONE_HEIGHT - 40 - 10, PHONE_WIDTH - 9 * 2, 40);
    _photoDetailCollectionView.contentOffset = CGPointMake(self.currentIndex * PHONE_WIDTH, 0);

}

#pragma mark -UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    LBphotoDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoDetailCellIdentifier forIndexPath:indexPath];
    cell.model = self.photoArray[indexPath.row];
    return cell;
}


- (UICollectionView *)photoDetailCollectionView {
    
    if (!_photoDetailCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(PHONE_WIDTH, kCollectionViewHeight);
        _photoDetailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64, PHONE_WIDTH, PHONE_HEIGHT - 64) collectionViewLayout:flowLayout];
        _photoDetailCollectionView.pagingEnabled = YES;
        _photoDetailCollectionView.delegate = self;
        _photoDetailCollectionView.dataSource = self;
        _photoDetailCollectionView.backgroundColor = [UIColor whiteColor];
        [_photoDetailCollectionView registerClass:[LBphotoDetailCell class] forCellWithReuseIdentifier:kPhotoDetailCellIdentifier];

    }
    return _photoDetailCollectionView;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
