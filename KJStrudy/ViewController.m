//
//  ViewController.m
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/04/10.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (strong, nonatomic) UIImageView *imageView;


@end

@implementation ViewController
- (id)init {
    self = [super init];
    if (self){
        self.title = @"Kojima sidemenu";
        self.view.backgroundColor = [UIColor redColor];
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image1"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_imageView];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self action:@selector(openLeftView)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openLeftView {
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

@end
