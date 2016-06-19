//
//  CollectionViewController.h
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/05/01.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionViewController;

@protocol CollectionViewControllerDelegate <NSObject>

- (void)collectionViewControllerViewDidFinish:(CollectionViewController *)controller;

@end

@interface CollectionViewController : UICollectionViewController
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) id <CollectionViewControllerDelegate> delegate;

@end

