//
//  ACViewController.h
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/05/10.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACViewController;

@protocol ACViewControllerDelegate <NSObject>

- (void)acViewControllerDidFinish:(ACViewController *)controller;

@end

@interface ACViewController : UIViewController
@property (weak, nonatomic) id <ACViewControllerDelegate> delegate;
@end
