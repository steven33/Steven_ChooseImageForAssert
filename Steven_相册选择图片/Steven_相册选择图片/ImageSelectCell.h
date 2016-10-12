//
//  ImageSelectCell.h
//  Steven_相册选择图片
//
//  Created by qugo on 16/6/30.
//  Copyright © 2016年 qugo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>


@interface ImageSelectCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIImageView *markView;

@property(nonatomic,strong)ALAsset *asset;
@property(nonatomic,assign)BOOL type;




@end
