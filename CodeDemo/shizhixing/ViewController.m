//
//  ViewController.m
//  CodeDemo
//
//  Created by YangXiao on 2020/9/28.
//  Copyright © 2020 YangXiao. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "CrossJudgeObj.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)onRefresh:(id)sender {
    __weak typeof(self) weakSelf = self;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSArray *arrTime = @[@"3600",@"7200",@"14400",@"21600",@"43200",@"86400"];
    NSArray *arrLab = @[self.lab1,self.label2,self.lab4,self.lab6,self.label2,self.lab24];
    for (int i  = 0; i < arrTime.count; i++) {
        NSString *strUrl = [NSString stringWithFormat:@"https://www.okex.com/api/swap/v3/instruments/ETH-USDT-SWAP/candles?granularity=%@",[arrTime objectAtIndex:i]];
        [manager GET:strUrl parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"success!");
                NSArray *arr = [((NSArray *)(responseObject)) objectAtIndex:1];
                float num1 = [(NSString *)([arr objectAtIndex:1]) floatValue];
                float num2 = [(NSString *)([arr objectAtIndex:4]) floatValue];
//                NSLog(@"%f",num1);
//                NSLog(@"%f",num2);
//                NSLog(@"%@",task.response.URL.absoluteString);
                NSString *str = task.response.URL.absoluteString;
                NSArray *arrStr = [str componentsSeparatedByString:@"granularity="];
                NSString *resultStr = [arrStr objectAtIndex:1];
                NSInteger index = [arrTime indexOfObject:resultStr];
                UILabel *resultLabel = [arrLab objectAtIndex:index];
                CrossTime crossTime = CrossTime1;
                switch (index) {
                    case 0:
                        crossTime = CrossTime1;
                        break;
                        
                    case 1:
                        crossTime = CrossTime2;
                        break;
                        
                    case 2:
                        crossTime = CrossTime4;
                        break;
                        
                    case 3:
                        crossTime = CrossTime6;
                        break;
                        
                    case 4:
                        crossTime = CrossTime12;
                        break;
                        
                    case 5:
                        crossTime = CrossTime24;
                        break;
                        
                    default:
                        break;
                }
                BOOL isCross = [CrossJudgeObj isCross:crossTime StartNum:num1 EndNum:num2];
                if (isCross) {
                    resultLabel.text = @"是";
                }else {
                    resultLabel.text = @"否";
                }
                weakSelf.view.backgroundColor = [UIColor whiteColor];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                weakSelf.view.backgroundColor = [UIColor redColor];
            }];;
    }
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
