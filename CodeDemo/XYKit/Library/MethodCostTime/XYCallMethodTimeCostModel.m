//
//  XYCallMethodTimeCostModel.m
//  CodeDemo
//
//  Created by YangXiao on 2020/8/7.
//  Copyright © 2020 YangXiao. All rights reserved.
//

#import "XYCallMethodTimeCostModel.h"

@implementation XYCallMethodTimeCostModel

- (NSString *)des {
    NSMutableString *str = [NSMutableString new];
    [str appendFormat:@"%2d| ",(int)_callDepth];
    [str appendFormat:@"%6.2f|",_timeCost * 1000.0];
    for (NSUInteger i = 0; i < _callDepth; i++) {
        [str appendString:@"  "];
    }
    [str appendFormat:@"%s[%@ %@]", (_isClassMethod ? "+" : "-"), _className, _methodName];
    return str;
}

@end
