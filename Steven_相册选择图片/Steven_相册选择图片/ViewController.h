//
//  ViewController.h
//  Steven_相册选择图片
//
//  Created by qugo on 16/6/30.
//  Copyright © 2016年 qugo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;


@end

