//
//  AssetViewController.m
//  Steven_相册选择图片
//
//  Created by qugo on 16/6/30.
//  Copyright © 2016年 qugo. All rights reserved.
//

#import "AssetViewController.h"
#import <objc/runtime.h>
#import "ChooseViewController.h"

@interface AssetViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;

@end

@implementation AssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(finishPickingAssets:)];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupAssets];
}
- (void)setupAssets
{
    if (!self.assets){
        self.assets = [[NSMutableArray alloc] init];
    }else{
        [self.assets removeAllObjects];
    }
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        
        if (asset){
            [self.assets addObject:asset];
            
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto])
                self.numberOfPhotos ++;
            if ([type isEqual:ALAssetTypeVideo])
                self.numberOfVideos ++;
        }else if (self.assets.count > 0){
            [self.collectionView reloadData];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assets.count-1 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionTop
                                                animated:YES];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}


#pragma mark - Actions
- (void)finishPickingAssets:(id)sender
{
    ChooseViewController *chooseVC = self.navigationController.viewControllers.firstObject;
    NSMutableArray *assets = [NSMutableArray array];
    for (ALAsset *asset in chooseVC.markSelectSet) {
        [assets addObject:asset];
    }

    if (chooseVC.assetBlock) {
        chooseVC.assetBlock(assets);
    }
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];

}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            
            interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    ImageSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    ALAsset *asset = self.assets[indexPath.row];
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    
    cell.asset = self.assets[indexPath.row];
    ChooseViewController *chooseVC = self.navigationController.viewControllers.firstObject;
    BOOL isSlect = NO;
    for (ALAsset *markAsset in chooseVC.markSelectSet) {
        ALAssetRepresentation *markRepresentation = [markAsset defaultRepresentation];
        if ([markRepresentation.url.description isEqualToString:representation.url.description]) {
            isSlect = YES;
        }
    }
    if (isSlect ==YES) {
        cell.type = YES;
    }else{
        cell.type = NO;
    }
    
    

    return cell;
}


#pragma mark - Collection View Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseViewController *chooseVC = self.navigationController.viewControllers.firstObject;
    if (chooseVC.markSelectSet.count>=10) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多可以选择10张图片" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }

    ALAsset *asset = self.assets[indexPath.row];
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    ALAsset *mark_Asset;
    for (ALAsset *markAsset in chooseVC.markSelectSet) {
        ALAssetRepresentation *markRepresentation = [markAsset defaultRepresentation];
        if ([markRepresentation.url.description isEqualToString:representation.url.description]) {
            mark_Asset = markAsset;
        }
    }
    
    if (mark_Asset) {
        [chooseVC.markSelectSet removeObject:mark_Asset];
    }else{
       [chooseVC.markSelectSet addObject:asset];
    }

    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexPath.item inSection:0]]];
}

#pragma mark - Title



#pragma mark -UI
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                     = CGSizeMake(self.view.bounds.size.width/4 -5, self.view.bounds.size.width/4-5);
        layout.sectionInset                 = UIEdgeInsetsMake(5.0, 5, 5, 5);
        layout.minimumInteritemSpacing      = .0;
        layout.minimumLineSpacing           = 5.0;
        layout.footerReferenceSize          = CGSizeMake(0, 44.0);
        
        _collectionView= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.collectionView registerClass:[ImageSelectCell class]
                forCellWithReuseIdentifier:@"cell"];
        
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}


@end
