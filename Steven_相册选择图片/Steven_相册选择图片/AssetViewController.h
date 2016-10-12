//
//  AssetViewController.h
//  Steven_相册选择图片
//
//  Created by qugo on 16/6/30.
//  Copyright © 2016年 qugo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import "ImageSelectCell.h"


@interface AssetViewController : UIViewController


@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end
