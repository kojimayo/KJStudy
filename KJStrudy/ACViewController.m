//
//  ACViewController.m
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/05/10.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

#import "ACViewController.h"
@import MobileCoreServices;

@interface ACViewController ()<UIImagePickerControllerDelegate>
- (IBAction)selectMedia:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *selectTitle;
- (IBAction)leftButtonAction:(UIBarButtonItem *)sender;

@end

@implementation ACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    //_selectTitle.text = title;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectMedia:(UIBarButtonItem *)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = @[(NSString*)kUTTypeMovie];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (IBAction)leftButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
