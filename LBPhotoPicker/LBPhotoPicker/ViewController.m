//
//  ViewController.m
//  LBPhotoPicker
//
//  Created by 李永方 on 2017/5/21.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import "LBPhotoListModel.h"
#import "LBPhotoPickerModel.h"
#import "LBPhotoListViewController.h"

@interface ViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) NSMutableArray *photoListArrary;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.selectButton];
    self.selectButton.frame = CGRectMake(100, 100, 100, 100);
}


- (void)selectButtonClick:(UIButton *)button {
    
    [self checkPermissionForPhotoLibrary];
}

- (UIButton *)selectButton {
    
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        _selectButton.backgroundColor = [UIColor redColor];
        [_selectButton setTitle:@"选择相册" forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (void)checkPermissionForPhotoLibrary {
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied ||[PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted ) {
        // 无法访问相册 在这里做出提示;
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在“设置->隐私->相册”设置为打开状态"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self pushToPhotpListVC];
    }else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        // 当未作出选择时，选择后再授权回调里加载相片
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self pushToPhotpListVC];
                }
            });
        }];
    }
}

- (void)pushToPhotpListVC {
    
    // 跳转
    LBPhotoListViewController *lbListVC = [[LBPhotoListViewController alloc] init];
    [self.navigationController pushViewController:lbListVC animated:YES];
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
    });
    
    // 将相机胶卷放到第一位
    if (self.photoListArrary && self.photoListArrary.count > 0) {
        
        
        for (LBPhotoListModel *listModel in self.photoListArrary) {
            
            if ([listModel.albumName isEqualToString:@"相机胶卷"]) {
                [self.photoListArrary insertObject:listModel atIndex:0];
            }
        }
    }
    
   
}

/**
 *  遍历相册资源
 */
- (void)enumerCollection:(PHAssetCollection *)collection {
    
    PHFetchOptions *option = [[PHFetchOptions alloc]init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:option];
    
    NSMutableArray *tempPhotoImageArray = [NSMutableArray array];
    NSMutableArray *tempVideoImageArray = [NSMutableArray array];
    
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
                LBPhotoPickerModel *picMode = [[LBPhotoPickerModel alloc] init];
                picMode.PHAsset = asset;
                [model.photoArray addObject:picMode];
//                NSDictionary * imageDic = @{@"PHAsset":asset,
//                                            @"isPhoto":@(1),
//                                            @"albumName":collection.localizedTitle,
//                                            @"stringMediaName":photoName,
//                                            @"extendName":extrendName};
//                
//                MDPMediaSourceModel * model = [MDPMediaSourceModel initWithDictionary:imageDic];
//                [tempPhotoImageArray addObject:model];
                
            }
            
            model.pictureNumber  = [NSString stringWithFormat:@"%zd",pictureNum];
        }
       
       
        // 获取封面
        if (model.photoArray.count > 0) {
            
           [[PHImageManager defaultManager] requestImageForAsset:[[model.photoArray firstObject] PHAsset] targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
               model.albumName = collection.localizedTitle;
               model.coverImage = result;
           }];
         [self.photoListArrary addObject:model];
        }
        
        
        
        
//        if (tempPhotoImageArray && tempPhotoImageArray.count >0) {
//            /// 添加图片相册的封面属性，数量等.
//            [[PHImageManager defaultManager]requestImageForAsset:[[tempPhotoImageArray firstObject] PHAsset] targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                /**
                 *
                 *  @param      albumName --->相册名字.
                 *  @param      postImage --->相册封面.
                 *  @param      pictureNumber --->相册图片数目.
                 *  @param      hasSelected ----->是否有选中的资源.
                 *
                 */
                
//                MDPMediaClassifyModel * model = [[MDPMediaClassifyModel alloc] init];
//                model.albumName = collection.localizedTitle;
//                model.assetCollectionSubtype = [NSString stringWithFormat:@"%zd",collection.assetCollectionSubtype];
//                model.postImage = result;
//                model.pictureNumber = [tempPhotoImageArray count];
//                model.hasSelected = NO;
                
//                [self.albumNamePictureArray addObject:model];
//            }];
        
//            [self.photoImageArray addObject:tempPhotoImageArray];
//        }
    
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            
//            self.allPhotoArray = tempPhotoImageArray;
        }
    }
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        // 否
    }else {
        
        // 跳转
        [self pushToPhotpListVC];
        

    }

}

- (NSMutableArray *)photoListArrary {
    
    if (!_photoListArrary) {
        _photoListArrary = [NSMutableArray array];
    }
    return _photoListArrary;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
