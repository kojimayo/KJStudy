//
//  CollectionViewController.m
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/05/01.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionFullViewController.h"
#import "MyCollectionViewCell.h"
#import "LeftViewController.h"

@import Photos;

#define kCellSpaceSize (5)
#define kImageCellViewSpace (6)

@interface CollectionViewController () 
{
    UICollectionViewFlowLayout *layout;
}
@property (strong, nonatomic)PHFetchResult *assetFetchResults;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property  CGRect lastPreheatRect;


- (IBAction)backItemBarButton:(id)sender;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"cell1";

- (void)awakeFromNib {
    _imageManager = [[PHCachingImageManager alloc] init];
    PHFetchOptions *allPhotoOptions = [[PHFetchOptions alloc] init];
    allPhotoOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotoOptions];
    _assetFetchResults = allPhotos;
    [self resetCachingAssets];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumLineSpacing =  kCellSpaceSize;
    layout.minimumInteritemSpacing = kCellSpaceSize;
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/3.0f - kCellSpaceSize, [UIScreen mainScreen].bounds.size.width/3.0f - kCellSpaceSize );
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateCacheAssets];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CollectionFullViewController class]]){
        CollectionFullViewController *viewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        viewController.asset = self.assetFetchResults[indexPath.item];
    }
}

- (IBAction)backItemBarButton:(id)sender {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if (self.delegate){
        [self.delegate collectionViewControllerViewDidFinish:self];
    }
    //[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.assetFetchResults[indexPath.item];
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //NSLog(@"koji %@ %d", cell.center, indexPath.item);
    
    cell.represntedAssetIdentifier = asset.localIdentifier;
    
    if (!cell){
        NSLog(@"Error Koji");
    } 
    
    //cell.backgroundColor = [UIColor greenColor];
    
    // Configure the cell
    cell.cellView.bounds = CGRectMake(0, 0, layout.itemSize.width, layout.itemSize.height);
    cell.cellView.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.cellView.layer.borderWidth = 3.0f;
    cell.cellView.layer.cornerRadius = layout.itemSize.width/2;
    cell.cellView.layer.masksToBounds = YES;
    
    UIView *imageContainView = [cell viewWithTag:2];
    imageContainView.frame = CGRectMake(kImageCellViewSpace, kImageCellViewSpace, layout.itemSize.width-(kImageCellViewSpace*2), layout.itemSize.height-(kImageCellViewSpace*2));
    imageContainView.layer.cornerRadius = (imageContainView.bounds.size.width)/2;
    imageContainView.layer.masksToBounds = YES;
    
    
    cell.cellImage.bounds = CGRectMake(0, 0, layout.itemSize.width-(kImageCellViewSpace*2), layout.itemSize.height-(kImageCellViewSpace*2));
    //cell.cellImage.layer.cornerRadius = (layout.itemSize.width-6)/2;
    //cell.cellImage.image = [UIImage imageNamed:@"standcat"];

    //cell.layer.cornerRadius = layout.itemSize.width/2;
    //cell.layer.masksToBounds = YES;
    
    cell.cellLabel.bounds = CGRectMake(0, 0, layout.itemSize.width, layout.itemSize.height/2);
    
    [self.imageManager requestImageForAsset:asset
                                targetSize:CGSizeMake(CGRectGetWidth(imageContainView.bounds), CGRectGetHeight(imageContainView.bounds))                              contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        //NSLog(@"%d %@ %@ %@ %@",indexPath.item, cell.thumbnailImage , result, asset, info);
        
        if ([cell.represntedAssetIdentifier isEqualToString:asset.localIdentifier]){
            cell.thumbnailImage = result;
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        cell.cellLabel.text = [formatter stringFromDate:asset.creationDate];
    }];

    return cell;
}

#pragma mark UISCrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCacheAssets];
}

#pragma mark Assets Caching

- (void)resetCachingAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.lastPreheatRect = CGRectZero;
}

- (void)updateCacheAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window];
    
    if (!isViewVisible) {
        return;
    }
    
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0, -0.5*CGRectGetHeight(preheatRect));
    
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.lastPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3){
        
        NSMutableArray *addAssetsPaths = [[NSMutableArray alloc] init];
        NSMutableArray *removeAssetsPaths = [[NSMutableArray alloc] init];
        
        [self computeDifferenceBetweenRect:self.lastPreheatRect andRect:preheatRect removeHandler:^(CGRect removeRect){
            NSArray *indexPaths = [self indexPathsForElementsInRect:removeRect];
            [removeAssetsPaths addObjectsFromArray:indexPaths];
        } addHandler:^(CGRect addRect){
            NSArray *indexPaths = [self indexPathsForElementsInRect:addRect];
            [addAssetsPaths addObjectsFromArray:indexPaths];
         }];
        
        NSArray *assetsToStartCache = [self assetsAtIndexPaths:addAssetsPaths];
        NSArray *assetsToStopCache = [self assetsAtIndexPaths:removeAssetsPaths];
        
        [self.imageManager startCachingImagesForAssets:assetsToStartCache
                                            targetSize:layout.itemSize
                                           contentMode:PHImageContentModeAspectFit
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCache
                                           targetSize:layout.itemSize
                                          contentMode:PHImageContentModeAspectFit
                                              options:nil];
        
        self.lastPreheatRect = preheatRect;
        
    }
    
}

- (NSArray *)indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) {
        return nil;
    }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}


- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removeHandler:(void (^)(CGRect removeRect))removeHandler addHandler:(void (^)(CGRect  addRect))addHandler {
    
    if (CGRectIntersectsRect(oldRect, newRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removeHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removeHandler(rectToRemove);
        }



    } else {
        addHandler(newRect);
        removeHandler(oldRect);
    }
}
         
- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetFetchResults[indexPath.item];
        [assets addObject:asset];
    }
             
    return assets;
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/




@end
