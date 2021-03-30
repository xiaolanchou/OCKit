//
//  LSViewController.m
//  CodeDemo
//
//  Created by YangXiao on 2020/12/21.
//  Copyright © 2020 YangXiao. All rights reserved.
//

#import "LSViewController.h"
#import "AFNetworking.h"

@interface LSViewController ()

@property (strong, nonatomic) NSMutableArray *coinList;
@property (strong, nonatomic) NSMutableDictionary *dataList;

@end

@implementation LSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)onAdd:(id)sender {
    if (self.coinTextField.text.length > 0) {
        [self saveCoinList:self.coinTextField.text];
        self.coinTextField.text = nil;
        [self.myTableView reloadData];
        [self.view endEditing:YES];
    }
}

- (IBAction)onSort:(id)sender {
    NSLog(@"%@",self.dataList);
    NSMutableArray *a = self.coinList;
    NSMutableDictionary *b = self.dataList;
    
    for(int i = 0; i< a.count-1; i++) {
        for(int j = 0;j< a.count-1-i;j++){
            NSString *key1 = [a objectAtIndex:j];
            NSString *key2 = [a objectAtIndex:j+1];
            NSString *value1 = ((NSMutableArray *)[b objectForKey:key1]).count > 0 ? [((NSMutableArray *)[b objectForKey:key1]) objectAtIndex:0]:@"0";
            NSString *value2 = ((NSMutableArray *)[b objectForKey:key2]).count > 0 ? [((NSMutableArray *)[b objectForKey:key2]) objectAtIndex:0]:@"0";
            if([value2 floatValue] < [value1 floatValue])
            {
                [a exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    [self.myTableView reloadData];
}

- (IBAction)onFresh:(id)sender {
//https://fapi.binance.com/futures/data/globalLongShortAccountRatio?symbol=BTCUSDT&period=4h&limit=1
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    for (int i  = 0; i < self.coinList.count; i++) {
        NSString *strUrl = [NSString stringWithFormat:@"https://fapi.binance.com/futures/data/globalLongShortAccountRatio?period=5m&limit=1&symbol=%@USDT",[self.coinList objectAtIndex:i]];
        [manager GET:strUrl parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"success!");
                NSDictionary *dic = nil;
                if (((NSArray *)(responseObject)).count > 0) {
                    dic = [((NSArray *)(responseObject)) objectAtIndex:0];
                    NSString *keyStr = [dic objectForKey:@"longShortRatio"];
                    NSString *str = task.response.URL.absoluteString;
                    NSArray *arrStr = [str componentsSeparatedByString:@"symbol="];
                    NSString *temStr = [arrStr objectAtIndex:1];
                    NSString *resultStr = [temStr substringToIndex:temStr.length-4];
                    NSMutableArray *arr = [weakSelf.dataList objectForKey:resultStr];
                    [arr removeAllObjects];
                    [arr addObject:keyStr];
                    [weakSelf.dataList setValue:arr forKey:resultStr];
                    
                    NSInteger index = [weakSelf.coinList indexOfObject:resultStr];
                    [weakSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            }];;
    }
}

#pragma mark UITableViewDelegate && UITableViewDatasouece
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.coinList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WYQStoryListTableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *keyStr = [self.coinList objectAtIndex:indexPath.row];
    NSMutableArray *array = [self.dataList objectForKey:keyStr];
    NSString *valueStr;
    if (array.count > 0) {
        valueStr = [array objectAtIndex:0];
    }else {
        valueStr = @"币种错误或未刷新";
    }
    NSString *str = [NSString stringWithFormat:@"%@:         %@",keyStr,valueStr];
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.text = str;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *str = [self.coinList objectAtIndex:indexPath.row];
        [self delCoinList:str];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSMutableArray *)coinList {
    if (!_coinList) {
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"DataCoinList"];
        if ([arr isKindOfClass:[NSArray class]]) {
            _coinList = [[NSMutableArray alloc] initWithArray:arr];
            return _coinList;
        }
        _coinList = [[NSMutableArray alloc] init];
        return _coinList;
    }
    return _coinList;
}

- (void)saveCoinList:(NSString *)str {
    if ([self.coinList containsObject:str]) {
        return;
    }
    [self.coinList addObject:str];
    [self saveDataList:str];
    [[NSUserDefaults standardUserDefaults] setObject:self.coinList forKey:@"DataCoinList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)delCoinList:(NSString *)str {
    [self.coinList removeObject:str];
    [self delDataList:str];
    [[NSUserDefaults standardUserDefaults] setObject:self.coinList forKey:@"DataCoinList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableDictionary *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableDictionary alloc] init];
        for (int i  = 0; i < self.coinList.count; i++) {
            NSString *str = [self.coinList objectAtIndex:i];
            [_dataList setValue:[[NSMutableArray alloc] init] forKey:str];
        }
        return _dataList;
    }
    return _dataList;
}

- (void)saveDataList:(NSString *)str {
    [self.dataList setValue:[[NSMutableArray alloc] init] forKey:str];
}

- (void)delDataList:(NSString *)str {
    [self.dataList removeObjectForKey:str];
}



@end
