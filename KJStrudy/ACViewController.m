//
//  ACViewController.m
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/05/10.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

#import "ACViewController.h"
@import MobileCoreServices;
@import AVKit;
@import AVFoundation;

@interface ACViewController ()<UIImagePickerControllerDelegate>
- (IBAction)selectMedia:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *selectTitle;
@property (strong, nonatomic) NSData *imageData;
- (IBAction)leftButtonAction:(UIBarButtonItem *)sender;
- (IBAction)actionSocial:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerview;

@end

@implementation ACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ActivityTestStoryboard" bundle:[NSBundle mainBundle]];
    NSLog(@"sub = %@", self.childViewControllers[0]);
    
    UIViewController *beforeview = self.childViewControllers[0];
    
    [beforeview willMoveToParentViewController:nil];
    //[beforeview.view removeFromSuperview];
    [beforeview removeFromParentViewController];
    
    UIViewController *newview = [storyboard instantiateViewControllerWithIdentifier:@"1"];
    NSLog(@"newview = %@", newview);
    
    [self addChildViewController:newview];
    [self ]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSLog(@"image pick URL= %@",url);
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    //_selectTitle.text = title;
    [self setImageData:data];
    
    AVPlayerViewController *playerViewController = (AVPlayerViewController *)self.childViewControllers[0];
    playerViewController.player = [AVPlayer playerWithURL:url];
    [playerViewController.player play];
    
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
        picker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeImage];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (IBAction)leftButtonAction:(UIBarButtonItem *)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate){
        [self.delegate acViewControllerDidFinish:self];
    }
}

- (IBAction)actionSocial:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* videoPath = [documentsDirectory stringByAppendingPathComponent:@"Test.MOV"];

    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:videoPath error:&error];
    BOOL success = [_imageData writeToFile:videoPath atomically:YES];
    if (success) {
        NSArray *activityItems = [NSArray arrayWithObjects:[NSURL fileURLWithPath:videoPath], nil];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    
}
@end
