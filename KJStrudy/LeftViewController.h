//
//  LeftViewController.h
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/04/26.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewController.h"
#import "ACViewController.h"
#import "STViewController.h"

@interface LeftViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, CollectionViewControllerDelegate, ACViewControllerDelegate>
@property (strong, nonatomic) UIColor *tintColor;
@end
