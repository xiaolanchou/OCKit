//
//  XYCallMethodTimeCostModel.h
//  CodeDemo
//
//  Created by YangXiao on 2020/8/7.
//  Copyright © 2020 YangXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYCallMethodTimeCostModel : NSObject

@property (nonatomic, strong) NSString *className;       //类名
@property (nonatomic, strong) NSString *methodName;      //方法名
@property (nonatomic, assign) BOOL isClassMethod;        //是否是类方法
@property (nonatomic, assign) NSTimeInterval timeCost;   //时间消耗
@property (nonatomic, assign) NSUInteger callDepth;      //Call 层级
@property (nonatomic, copy) NSString *path;              //路径
@property (nonatomic, assign) BOOL lastCall;             //是否是最后一个 Call
@property (nonatomic, assign) NSUInteger frequency;      //访问频次
@property (nonatomic, strong) NSArray <XYCallMethodTimeCostModel *> *subCosts;

- (NSString *)des;

@end

NS_ASSUME_NONNULL_END
