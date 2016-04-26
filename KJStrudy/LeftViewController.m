//
//  LeftViewController.m
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/04/26.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "LeftViewCell.h"

@interface LeftViewController ()
@property (strong, nonatomic) NSArray *titlesArray;
@end

@implementation LeftViewController
- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _titlesArray = @[@"Open Right View",
                        @"",
                        @"Item1",
                        @"Item2",
                        @"Item3"];
        [self.tableView registerClass:[LeftViewCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.contentInset = UIEdgeInsetsMake(44.f, 0.f, 44.f, 0.f);
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.allowsSelection = YES;
        self.clearsSelectionOnViewWillAppear = NO;
    }
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell){
        cell.textLabel.text = _titlesArray[indexPath.row];
        cell.separatorView.hidden = !(indexPath.row != 0 && indexPath.row != 1 );
        //NSLog(@"koji %d %@",indexPath.row, cell);
        cell.userInteractionEnabled = (indexPath.row != 1);
    
        cell.tintColor = _tintColor;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) return 22.f;
    else return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s ",  __PRETTY_FUNCTION__);

    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = [UIColor whiteColor];
    viewController.title = _titlesArray[indexPath.row];
    
    [kNavigationController pushViewController:viewController animated:YES];
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];

}


@end
