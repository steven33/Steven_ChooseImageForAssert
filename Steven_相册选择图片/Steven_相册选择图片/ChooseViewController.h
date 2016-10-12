//
//  ChooseViewController.h
//  Steven_相册选择图片
//
//  Created by qugo on 16/6/30.
//  Copyright © 2016年 qugo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetViewController.h"

typedef void(^AssetBlock)(NSMutableArray *assets);
@interface ChooseViewController : UIViewController

@property(nonatomic,strong)AssetBlock assetBlock;
@property(nonatomic,strong)NSMutableSet *markSelectSet;

@end
