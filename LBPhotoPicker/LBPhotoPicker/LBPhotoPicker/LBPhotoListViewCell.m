//
//  LBPhotoListViewCellTableViewCell.m
//  LBPhotoPicker
//
//  Created by 李永方 on 2017/5/21.
//  Copyright © 2017年 liYongfang. All rights reserved.
//

#import "LBPhotoListViewCell.h"

@interface LBPhotoListViewCell()

/** 图片*/
@property (nonatomic, strong) UIImageView * photoImage;
/** 分类名*/
@property (nonatomic, strong) UILabel * classifyLabel;
/** 数量*/
@property (nonatomic, strong) UILabel * photoNumber;

@end

@implementation LBPhotoListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpUI];
    }

    return self;
}

- (void)setUpUI{
    
    [self.contentView addSubview:self.photoImage];
    [self.contentView addSubview:self.classifyLabel];
    [self.contentView addSubview:self.photoNumber];
    self.photoImage.frame = CGRectMake(9, 8, 70, 70);
    self.classifyLabel.frame = CGRectMake(CGRectGetMaxX(self.photoImage.frame) + 17, 86 /2 - 10 - 17 / 2  , [UIScreen mainScreen].bounds.size.width - 24 - 9 - 70 - 17 , 17);
    self.photoNumber.frame = CGRectMake(CGRectGetMaxX(self.photoImage.frame) + 17, 86/2 + 10 , [UIScreen mainScreen].bounds.size.width - 24 - 9 - 70 - 17, 9);

}

- (void)setModel:(LBPhotoListModel *)model {
    
    _model = model;
    self.photoImage.image = model.coverImage;
    self.classifyLabel.text = model.albumName;
    self.photoNumber.text = model.pictureNumber;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


#pragma mark -lazy
- (UIImageView *)photoImage {
    if (!_photoImage) {
        _photoImage = [[UIImageView alloc] init];
    }
    return _photoImage;
}

- (UILabel *)classifyLabel {
    
    if (!_classifyLabel) {
        _classifyLabel = [[UILabel alloc] init];
        _classifyLabel.font = [UIFont systemFontOfSize:17];
        _classifyLabel.textColor = [UIColor blackColor];
    }
    return _classifyLabel;
}

- (UILabel *)photoNumber {
    
    if (!_photoNumber) {
        _photoNumber = [[UILabel alloc] init];
        _photoNumber.font = [UIFont systemFontOfSize:10];
        _photoNumber.textColor = [UIColor grayColor];
    }
    return _photoNumber;
}


@end
