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
#import "LBPhotoSelectTipModel.h"

@interface ViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) NSMutableArray *photoListArrary;

/** 上传提示数组  这部分需要外界控制*/
@property (nonatomic, strong) NSMutableArray *upLoadTipArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.selectButton];
    self.selectButton.frame = CGRectMake(100, 100, 100, 100);
    [self initDate];

}

- (void)initDate {
    
    [self.upLoadTipArray removeAllObjects];
    for (int i = 0; i < 5; i ++) {
        LBPhotoSelectTipModel *model = [[LBPhotoSelectTipModel alloc] init];
        model.upLoadIndex = i + 1;
        model.tipText = [NSString stringWithFormat:@"请上传证件照 %zd",i + 1];
        [self.upLoadTipArray addObject:model];
    }
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
    [self initDate];
    lbListVC.upLoadTipArray = self.upLoadTipArray;
    [self.navigationController pushViewController:lbListVC animated:YES];
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
