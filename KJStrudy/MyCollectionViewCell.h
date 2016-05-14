//
//  CollectionViewCell.h
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/05/01.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

@property (strong, nonatomic) UIImage *thumbnailImage;
@property (copy, nonatomic) NSString *represntedAssetIdentifier;

@end
