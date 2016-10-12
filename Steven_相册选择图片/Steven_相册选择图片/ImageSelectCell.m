//
//  ImageSelectCell.m
//  Steven_相册选择图片
//
//  Created by qugo on 16/6/30.
//  Copyright © 2016年 qugo. All rights reserved.
//

#import "ImageSelectCell.h"
#import <objc/runtime.h>


@implementation ImageSelectCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.opaque                     = YES;
        self.isAccessibilityElement     = YES;
        self.accessibilityTraits        = UIAccessibilityTraitImage;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_imageView];
        
        _markView = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView.bounds.size.width - 31, 0, 31, 31)];
        [self.contentView addSubview:_markView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
}

- (void)setAsset:(ALAsset *)asset
{
    if (_asset != asset) {
        _asset = asset;
    }

    
    self.imageView.image =  [UIImage imageWithCGImage:asset.thumbnail];

    
}
- (void)setType:(BOOL)type{
    if (_type!=type) {
        _type= type;
    }
    if (_type) {
        _markView.image = [UIImage imageNamed:@"CTAssetsPickerChecked"];
    }else{
        _markView.image = nil;
    }
}

@end
