//
//  LBPhotoPickerViewCell.m
//  LBPhotoPicker
//
//  Created by liyongfang on 2017/5/23.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import "LBPhotoPickerViewCell.h"
#import <Photos/Photos.h>

@interface LBPhotoPickerViewCell()

/** 相册图片 */
@property (nonatomic, strong) UIImageView *photoImageView;

/** 选中按钮 */
@property (nonatomic, strong) UIButton *selectButton;


@end

@implementation LBPhotoPickerViewCell

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI {
    
    [self.contentView addSubview:self.photoImageView];
    [self.contentView addSubview:self.selectButton];
    self.photoImageView.frame = self.contentView.bounds;
    self.selectButton.frame = CGRectMake(self.contentView.bounds.size.width - 40, 0, 40,40);
    self.selectButton.backgroundColor = [UIColor grayColor];
}

- (void)clickSelctButton:(UIButton *)button {
    
    button.selected = !button.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSelectButtonWithcellIndex:)]) {
        [self.delegate didClickSelectButtonWithcellIndex:self.cellIndex];
    }
}

- (void)setModel:(LBPhotoPickerModel *)model {
    
    _model = model;
    if (model.selected) {
        self.selectButton.selected = YES;
        self.selectButton.backgroundColor = [UIColor redColor];
        [self.selectButton setTitle:[NSString stringWithFormat:@"%zd",model.upLoadIndex] forState:UIControlStateNormal];
        
    }else{
        
        self.selectButton.selected = NO;
        self.selectButton.backgroundColor = [UIColor grayColor];
         [self.selectButton setTitle:@"" forState:UIControlStateNormal];
        _model.upLoadIndex = 0;
    }
    //创建options
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.synchronous = NO;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    if (model.thumail) {
        self.photoImageView.image = model.thumail;
    }else {
        
        
        [[PHCachingImageManager defaultManager]requestImageForAsset:model.PHAsset targetSize:CGSizeMake(160, 160) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photoImageView.image = result;
                model.thumail = result;
            });
        }];
    }
    
    if (!model.originalImage) {
        
        
    }
}



#pragma mark -lazy
- (UIImageView *)photoImageView {
    
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _photoImageView;
}

- (UIButton *)selectButton {

    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        [_selectButton addTarget:self action:@selector(clickSelctButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;

}


@end
