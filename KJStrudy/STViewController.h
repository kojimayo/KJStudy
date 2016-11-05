//
//  STViewController.h
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/10/28.
//  Copyright © 2016 小島 佳幸. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STViewController;

@protocol STViewControllerDelegate <NSObject>
- (void)stViewControllerDidFinish:(STViewController *)controller;

@end



@interface STViewController : UIViewController
@property (weak, nonatomic) id <STViewControllerDelegate> delegate;

@end
