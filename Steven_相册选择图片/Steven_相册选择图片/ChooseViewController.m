//
//  ChooseViewController.m
//  Steven_相册选择图片
//
//  Created by qugo on 16/6/30.
//  Copyright © 2016年 qugo. All rights reserved.
//

#import "ChooseViewController.h"

@interface ChooseViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *groupArr;

@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的相册";
    
    [self.view addSubview:self.tableView];
    [self setupGroup];
   
}
- (void)setupGroup
{
    [self.groupArr removeAllObjects];
    ALAssetsFilter *assetsFilter = [ALAssetsFilter allAssets];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group,BOOL *stop){
        if (group) {
            [group setAssetsFilter:assetsFilter];
            if (group.numberOfAssets > 0) {
                [self.groupArr addObject:group];
            }
        }else{
            [self.tableView reloadData];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        //失败。。。
    };
    // Enumerate Camera roll first
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
    // Then all other groups
    NSUInteger type =
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
}
#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifyCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyCell];
    }
    [self bind:[self.groupArr objectAtIndex:indexPath.row] forcell:cell];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetViewController *vc = [[AssetViewController alloc] init];
    vc.assetsGroup = self.groupArr[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bind:(ALAssetsGroup *)assetsGroup forcell:(UITableViewCell *)cell
{
    CGImageRef posterImage      = assetsGroup.posterImage;
    size_t height               = CGImageGetHeight(posterImage);
    float scale                 = height / 40;
    
    cell.imageView.image        = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    cell.textLabel.text         = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text   = [NSString stringWithFormat:@"%ld", (long)[assetsGroup numberOfAssets]];
    cell.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
}


#pragma mark-UI
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (ALAssetsLibrary *)assetsLibrary{
    if (!_assetsLibrary) {
        _assetsLibrary = [self.class defaultAssetsLibrary];
    }
    return _assetsLibrary;
}
+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}
- (NSMutableArray *)groupArr{
    if (!_groupArr) {
        _groupArr = [NSMutableArray array];
    }
    return _groupArr;
}

- (NSMutableSet *)markSelectSet{
    if (!_markSelectSet) {
        _markSelectSet = [NSMutableSet set];
    }
    return _markSelectSet;
}



@end
