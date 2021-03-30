//
//  LSViewController.h
//  CodeDemo
//
//  Created by YangXiao on 2020/12/21.
//  Copyright © 2020 YangXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *coinTextField;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)onAdd:(id)sender;
- (IBAction)onFresh:(id)sender;
- (IBAction)onSort:(id)sender;

@end

NS_ASSUME_NONNULL_END
