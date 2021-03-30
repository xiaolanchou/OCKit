//
//  XYCallTrace.m
//  CodeDemo
//
//  Created by YangXiao on 2020/8/21.
//  Copyright © 2020 YangXiao. All rights reserved.
//

#import "XYCallTrace.h"
#import "XYCallLib.h"
#import "XYCallMethodTimeCostModel.h"

@implementation XYCallTrace

#pragma mark - Trace
#pragma mark - OC Interface
+ (void)start {
    smCallTraceStart();
}
+ (void)startWithMaxDepth:(int)depth {
    smCallConfigMaxDepth(depth);
    [XYCallTrace start];
}
+ (void)startWithMinCost:(double)ms {
    smCallConfigMinTime(ms * 1000);
    [XYCallTrace start];
}
+ (void)startWithMaxDepth:(int)depth minCost:(double)ms {
    smCallConfigMaxDepth(depth);
    smCallConfigMinTime(ms * 1000);
    [XYCallTrace start];
}
+ (void)stop {
    smCallTraceStop();
}
+ (void)save {
    NSMutableString *mStr = [NSMutableString new];
    NSArray<XYCallMethodTimeCostModel *> *arr = [self loadRecords];
    for (XYCallMethodTimeCostModel *model in arr) {
        //记录方法路径
        model.path = [NSString stringWithFormat:@"[%@ %@]",model.className,model.methodName];
        [self appendRecord:model to:mStr];
    }
    NSLog(@"狗屁:%@",mStr);
}
+ (void)stopSaveAndClean {
    [XYCallTrace stop];
    [XYCallTrace save];
    smClearCallRecords();
}
+ (void)appendRecord:(XYCallMethodTimeCostModel *)cost to:(NSMutableString *)mStr {
    [mStr appendFormat:@"%@\n path%@\n",[cost des],cost.path];
    if (cost.subCosts.count < 1) {
        cost.lastCall = YES;
        //记录到数据库中
//        [[SMLagDB shareInstance] addWithClsCallModel:cost];
    } else {
        for (XYCallMethodTimeCostModel *model in cost.subCosts) {
            if ([model.className isEqualToString:@"SMCallTrace"]) {
                break;
            }
            //记录方法的子方法的路径
            model.path = [NSString stringWithFormat:@"%@ - [%@ %@]",cost.path,model.className,model.methodName];
            [self appendRecord:model to:mStr];
        }
    }
    NSLog(@"狗屁:%@",mStr);
}
+ (NSArray<XYCallMethodTimeCostModel *>*)loadRecords {
    NSMutableArray<XYCallMethodTimeCostModel *> *arr = [NSMutableArray new];
    int num = 0;
    smCallRecord *records = smGetCallRecords(&num);
    for (int i = 0; i < num; i++) {
        smCallRecord *rd = &records[i];
        XYCallMethodTimeCostModel *model = [XYCallMethodTimeCostModel new];
        model.className = NSStringFromClass(rd->cls);
        model.methodName = NSStringFromSelector(rd->sel);
        model.isClassMethod = class_isMetaClass(rd->cls);
        model.timeCost = (double)rd->time / 1000000.0;
        model.callDepth = rd->depth;
        [arr addObject:model];
    }
    NSUInteger count = arr.count;
    for (NSUInteger i = 0; i < count; i++) {
        XYCallMethodTimeCostModel *model = arr[i];
        if (model.callDepth > 0) {
            [arr removeObjectAtIndex:i];
            //Todo:不需要循环，直接设置下一个，然后判断好边界就行
            for (NSUInteger j = i; j < count - 1; j++) {
                //下一个深度小的话就开始将后面的递归的往 sub array 里添加
                if (arr[j].callDepth + 1 == model.callDepth) {
                    NSMutableArray *sub = (NSMutableArray *)arr[j].subCosts;
                    if (!sub) {
                        sub = [NSMutableArray new];
                        arr[j].subCosts = sub;
                    }
                    [sub insertObject:model atIndex:0];
                }
            }
            i--;
            count--;
        }
    }
    return arr;
}


@end
