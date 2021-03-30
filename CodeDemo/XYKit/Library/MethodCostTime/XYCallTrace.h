//
//  XYCallTrace.h
//  CodeDemo
//
//  Created by YangXiao on 2020/8/21.
//  Copyright © 2020 YangXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYCallCore.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYCallTrace : NSObject

+ (void)start; //开始记录
+ (void)startWithMaxDepth:(int)depth;
+ (void)startWithMinCost:(double)ms;
+ (void)startWithMaxDepth:(int)depth minCost:(double)ms;
+ (void)stop; //停止记录
+ (void)save; //保存和打印记录，如果不是短时间 stop 的话使用 saveAndClean
+ (void)stopSaveAndClean; //停止保存打印并进行内存清理
//int smRebindSymbols(struct smRebinding rebindings[], size_t rebindings_nel);

@end

NS_ASSUME_NONNULL_END
