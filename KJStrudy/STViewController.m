//
//  STViewController.m
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/10/28.
//  Copyright © 2016 小島 佳幸. All rights reserved.
//

#import "STViewController.h"


@interface STViewController ()
@property (strong, nonatomic) NSString *resultString;
@property (strong, nonatomic) NSString *resultFortuneContent;
@property (strong, nonatomic) NSString *resultFortuneItem;
@property (strong, nonatomic) NSString *resultFortuneColor;

@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSString *constellation;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthDay;
@property (weak, nonatomic) IBOutlet UITextView *fortuneText;
- (IBAction)backButtonTap:(id)sender;
- (IBAction)sendRequestButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *consellationLabel;
@property (weak, nonatomic) IBOutlet UITextField *fortuneItemText;
@property (weak, nonatomic) IBOutlet UITextField *fortuneColorText;


@end

@implementation STViewController
NSDictionary *constellationDic = NULL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (constellationDic == NULL){
        constellationDic = @{@"山羊座":@[@"01/01",@"01/19"],
                             @"水瓶座":@[@"01/20",@"02/18"],
                             @"魚座":@[@"02/19",@"03/20"],
                             @"牡羊座":@[@"03/21",@"04/19"],
                             @"牡牛座":@[@"04/20",@"05/20"],
                             @"双子座":@[@"05/21",@"06/21"],
                             @"蟹座":@[@"06/22",@"07/22"],
                             @"獅子座":@[@"07/23",@"08/22"],
                             @"乙女座":@[@"08/23",@"09/22"],
                             @"天秤座":@[@"09/23",@"10/23"],
                             @"蠍座":@[@"10/24",@"11/22"],
                             @"射手座":@[@"11/23",@"12/21"],
                             @"山羊座":@[@"12/22",@"12/31"],
                            };
    }
    self.fortuneText.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonTap:(id)sender {
    if (self.delegate){
        [self.delegate stViewControllerDidFinish:self];
    }
}

- (NSString *)getConstellation:(NSDate *)birthday {
    __block NSString *constellation = NULL;
    NSString *birthMonthDay;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd"];
    birthMonthDay = [format stringFromDate:birthday];
    
    [constellationDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        NSArray *term = (NSArray *)obj;
        
        if (([birthMonthDay compare:term[0]] == NSOrderedSame ||
            [birthMonthDay compare:term[0]] == NSOrderedDescending) &&
            ([birthMonthDay compare:term[1]] == NSOrderedSame ||
             [birthMonthDay compare:term[1]] == NSOrderedAscending)){
                constellation = [NSString stringWithString:(NSString *)key];
                *stop = TRUE;
            }
        
    }];
    
    return constellation;
}

- (IBAction)sendRequestButton:(UIButton *)sender {
    _resultString = @"- did not set it";
    self.resultString = @"error";
    
    NSBlockOperation *finish = [NSBlockOperation blockOperationWithBlock:^(){
        NSLog(@"%s", __FUNCTION__);
        self.fortuneText.text = self.resultFortuneContent;
        self.fortuneItemText.text = self.resultFortuneItem;
        self.fortuneColorText.text = self.resultFortuneColor;
    }];
    
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSString *todayString = [dateFormat stringFromDate:[NSDate date]];
    
    self.constellation = [self getConstellation:_birthDay.date];
    self.consellationLabel.text = self.constellation;
        
    NSString *dateString = @"http://api.jugemkey.jp/api/horoscope/free/";
    NSString *urlString = [dateString stringByAppendingString:todayString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary *fortunedic;
        
        NSLog(@"completion handler");
        NSLog(@"http response %@", httpResponse);
        
        if (httpResponse.statusCode == 200){
            self.resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"Result String = %@", self.resultString);
            
            {
                NSError *err;
                NSString *pathName = [@"horoscope." stringByAppendingString:todayString];
                fortunedic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                NSArray *items = (NSArray *)[fortunedic valueForKeyPath:pathName];
                
                __weak typeof(self) wself = self;
                [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                    NSDictionary *dic = (NSDictionary *)obj;
                    NSLog(@"%@", [dic valueForKey:@"sign"]);
                    if ([self.constellation compare:[dic valueForKey:@"sign"]] == NSOrderedSame){
                        wself.resultFortuneContent =
                            [dic valueForKey:@"content"];
                        wself.resultFortuneItem =
                            [dic valueForKey:@"item"];
                        wself.resultFortuneColor =
                            [dic valueForKey:@"color"];
                    }
                    
                }];
            }
            
        
            NSOperationQueue *mainQ = [NSOperationQueue mainQueue];
            [mainQ addOperation:finish];
        }else{
            NSLog(@"Error: http status code[%ld]",httpResponse.statusCode);
        }
        
        [session finishTasksAndInvalidate];
    }];
    
    [task resume];

    
    
}
@end
