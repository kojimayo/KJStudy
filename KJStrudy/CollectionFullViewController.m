//
//  CollectionFullViewController.m
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/05/04.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

#import "CollectionFullViewController.h"

@interface CollectionFullViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *fullImage;

@end

@implementation CollectionFullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = NO;
    
    self.fullImage.contentMode = UIViewContentModeScaleAspectFit;
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:[self targetSize] contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.fullImage.image = result;
    }];

    
}


- (CGSize)targetSize {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(CGRectGetWidth(self.fullImage.bounds) * scale, CGRectGetHeight(self.fullImage.bounds) * scale);
    return targetSize;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
