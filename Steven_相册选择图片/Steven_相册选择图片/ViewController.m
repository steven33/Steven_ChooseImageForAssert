//
//  ViewController.m
//  Steven_相册选择图片
//
//  Created by qugo on 16/6/30.
//  Copyright © 2016年 qugo. All rights reserved.
//

#import "ViewController.h"
#import "ChooseViewController.h"

@interface ViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *assets;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *clearButton =
    [[UIBarButtonItem alloc] initWithTitle:@"清除"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(clearAssets:)];
    
    
    UIBarButtonItem *addButton =
    [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(pickAssets:)];
    
    self.navigationItem.leftBarButtonItem = clearButton;
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.collectionView];
}
#pragma mark -action
//清除图片
- (void)clearAssets:(id)sender{
    [self.assets removeAllObjects];
    [self.collectionView reloadData];
}
- (void)pickAssets:(id)sender{
    ChooseViewController *picker = [[ChooseViewController alloc] init];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:picker];
    
    picker.markSelectSet = [NSMutableSet setWithArray:self.assets];
    
    __block ViewController *thisVC = self;
    picker.assetBlock = ^(NSMutableArray *assets){
        thisVC.assets = assets;
        [thisVC.collectionView reloadData];
    };
    
    [self presentViewController:nv animated:YES completion:NULL];
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
    
    cell.asset = self.assets[indexPath.row];

    
    return cell;
}
#pragma mark -privite
- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}
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
