//
//  LBPhotoPickerDetailController.m
//  LBPhotoPicker
//
//  Created by liyongfang on 2017/5/26.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import "LBPhotoPickerDetailController.h"
#import "LBphotoDetailCell.h"
#import "LBPhotoSelectTipModel.h"
/// 屏幕宽高.
#define PHONE_WIDTH         [[UIScreen mainScreen] bounds].size.width
#define PHONE_HEIGHT        [[UIScreen mainScreen] bounds].size.height
#define kCollectionViewHeight (PHONE_HEIGHT - 64 - 60)
static  NSString *kPhotoDetailCellIdentifier = @"kPhotoDetailCellIdentifier";

@interface LBPhotoPickerDetailController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate
>

@property (nonatomic, strong) UICollectionView *photoDetailCollectionView;

/** 下一步按钮 */
@property (nonatomic, strong) UIButton *nextTipBtn;
/** 提示label */
@property (nonatomic, strong) UILabel *tipLble;
/** 选中点击按钮 */
@property (nonatomic, strong) UIButton *rightBtn;



@end

@implementation LBPhotoPickerDetailController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpView];
    [self updateTipText];
}

- (void)setUpNav {
    
    //自定义UIView
    UIButton *btn=[[UIButton alloc]init];
    //设置按钮的背景图片（默认/高亮）
    [btn setBackgroundImage:[UIImage imageNamed:@"photo_selected"] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:@"photo_unSelect"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 26, 26);
    [btn addTarget:self action:@selector(selectPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = btn;
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)setUpView {
    
    [self setUpNav];
    [self.view addSubview:self.photoDetailCollectionView];
    [self.view addSubview:self.tipLble];
    [self.view addSubview:self.nextTipBtn];
    
    self.photoDetailCollectionView.frame = CGRectMake(0, 64, PHONE_WIDTH, kCollectionViewHeight);
    self.tipLble.frame = CGRectMake(0, PHONE_HEIGHT - 60 - 5 - 36, PHONE_WIDTH, 36);
    self.nextTipBtn.frame = CGRectMake(9, PHONE_HEIGHT - 40 - 10, PHONE_WIDTH - 9 * 2, 40);
    _photoDetailCollectionView.contentOffset = CGPointMake(self.currentIndex * PHONE_WIDTH, 0);
    LBPhotoPickerModel *model = self.photoArray[self.currentIndex];
    self.rightBtn.selected = model.selected;
}

#pragma mark -btClick
- (void)selectPhotoClick:(UIButton *)button {

    if (self.selectedArray.count >= self.upLoadTipArray.count) {
        return;
    }
    button.selected = !button.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSelectPhotoButtonWithCurrentIndex:)]) {
        [self.delegate didClickSelectPhotoButtonWithCurrentIndex:self.currentIndex];
    }
    
    [self updateTipText];
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

#pragma mark - delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 设置button选中状态
    NSInteger index = scrollView.contentOffset.x /  PHONE_WIDTH;
    if (self.currentIndex != index) {
        self.currentIndex = index;
        LBPhotoPickerModel *model = self.photoArray[index];
        self.rightBtn.selected = model.selected;
    }
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


// 更新上传提示信息
- (void)updateTipText {
    
    if (self.upLoadTipArray.count > 0) {
        
        [self.nextTipBtn setTitle:[NSString stringWithFormat:@"下一步(%zd/%zd)",self.selectedArray.count ,self.upLoadTipArray.count] forState:UIControlStateNormal];
        
        for (int i = 0; i < self.upLoadTipArray.count; i++ ) {
            
            LBPhotoSelectTipModel *tipMode = self.upLoadTipArray [i];
            
            if (tipMode.isSelected == NO) {
    
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
