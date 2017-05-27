//
//  LBPhotoListViewController.m
//  LBPhotoPicker
//
//  Created by 李永方 on 2017/5/21.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import "LBPhotoListViewController.h"
#import "LBPhotoListViewCell.h"
#import <Photos/Photos.h>
#import "LBPhotoListModel.h"
#import "LBPhotoPickerModel.h"
#import "LBPhotoListViewController.h"
#import "LBPhotoPickerController.h"
#import "LBPhotoSelectTipModel.h"
#import "LBPhotoPickerModel.h"

static NSString *lbPhotoListViewCellID = @"LBPhotoListViewCellID";

@interface LBPhotoListViewController () <UITableViewDelegate, UITableViewDataSource>
/* 相册列表 **/
@property (nonatomic, strong) UITableView *photoListTableView;

/** 所选的照片数组 */
@property (nonatomic, strong) NSMutableArray *upLoadPhotoModelArrary;




@end

@implementation LBPhotoListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.photoListTableView];

    self.title = @"相簿";
    [self checkPermissionForPhotoLibrary];
    self.photoListTableView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
}


- (void)initDate {
    
    [self.upLoadPhotoModelArrary removeAllObjects];
    for (int i = 0; i < 5; i ++) {
        LBPhotoSelectTipModel *model = [[LBPhotoSelectTipModel alloc] init];
        model.upLoadIndex = i + 1;
        model.tipText = self.upLoadTipArray[i];
        model.isSelected = NO;
        [self.upLoadPhotoModelArrary addObject:model];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.photoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBPhotoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lbPhotoListViewCellID];
    cell.model = self.photoArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.photoArray.count == 0) {
        return 0;
    }
    return 86;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LBPhotoPickerController *photoPickerVC = [[LBPhotoPickerController alloc] init];
    LBPhotoListModel *listModel = self.photoArray[indexPath.row];
    
    photoPickerVC.dataArray =  [listModel.photoPickerArray mutableCopy];
   ;
    [self initDate];
    photoPickerVC.upLoadTipArray = self.upLoadPhotoModelArrary;
    photoPickerVC.title = listModel.albumName;
    [self.navigationController pushViewController:photoPickerVC animated:YES];
}


- (void)checkPermissionForPhotoLibrary {
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied ||[PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted ) {
        // 无法访问相册 在这里做出提示;
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在“设置->隐私->相册”设置为打开状态"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self addAlbumResourceOther];
    }else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        // 当未作出选择时，选择后再授权回调里加载相片
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self addAlbumResourceOther];
                }
            });
        }];
    }
}

- (void)addAlbumResourceOther {
    
    // 获取用户自定义相册
    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 获取系统相册
    PHFetchResult *customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 遍历系统相册
        for (PHAssetCollection *collection in collections) {
            [self enumerCollection:collection];
        }
        
        for (PHAssetCollection *collection in customCollections) {
            [self enumerCollection:collection];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新数据
            [self.photoListTableView reloadData];
        });
        
    });
}

/**
 *  遍历相册资源
 */
- (void)enumerCollection:(PHAssetCollection *)collection {
    
    PHFetchOptions *option = [[PHFetchOptions alloc]init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:option];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    if ([assets count] > 0) {
        
        NSInteger pictureNum = 0;
        
        LBPhotoListModel *model = [[LBPhotoListModel alloc] init];
        
        for (PHAsset * asset in assets) {
            // 相册名字
            NSString * photoName =[asset valueForKey:@"filename"];
            // 扩展名
            NSString * extrendName = [[photoName componentsSeparatedByString:@"."] lastObject];
            // 判断照片和视频
            if (asset.mediaType == PHAssetMediaTypeImage) {
                //  照片
                pictureNum++;
                [model.photoPickerArray addObject:asset];
            }
            
            model.pictureNumber  = [NSString stringWithFormat:@"%zd",pictureNum];
        }
        // 获取封面
        if (model.photoPickerArray.count > 0) {
            
            [[PHImageManager defaultManager] requestImageForAsset:[model.photoPickerArray firstObject] targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                model.albumName = collection.localizedTitle;
                model.coverImage = result;
            }];
            if ([model.albumName isEqualToString:@"相机胶卷"]) {
                [self.photoArray insertObject:model atIndex:0];
            }else{
                [self.photoArray addObject:model];
            }
        }

    }
}

#pragma mark- lazy
- (UITableView *)photoListTableView {
    
    if (!_photoListTableView) {
        _photoListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _photoListTableView.delegate = self;
        _photoListTableView.dataSource = self;
        [_photoListTableView registerClass:[LBPhotoListViewCell class] forCellReuseIdentifier:lbPhotoListViewCellID];
        _photoListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _photoListTableView;
}


- (NSMutableArray *)photoArray {
    
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (NSMutableArray *)upLoadTipArray {

    if (!_upLoadTipArray) {
        _upLoadTipArray = [NSMutableArray array];
    }
    return _upLoadTipArray;
}

- (NSMutableArray *)upLoadPhotoModelArrary {

    if (!_upLoadPhotoModelArrary) {
        _upLoadPhotoModelArrary = [NSMutableArray array];
    }
    return _upLoadPhotoModelArrary;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
