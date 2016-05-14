//
//  CollectionViewCell.m
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/05/01.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor redColor];
        
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.cellImage.image = nil;
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    self.cellImage.image = thumbnailImage;
    _thumbnailImage = thumbnailImage;
}


@end
