//
//  CrossJudgeObj.m
//  CodeDemo
//
//  Created by YangXiao on 2020/9/28.
//  Copyright © 2020 YangXiao. All rights reserved.
//

#import "CrossJudgeObj.h"

@implementation CrossJudgeObj

+ (BOOL)isCross:(CrossTime)crossTime StartNum:(float)startNum EndNum:(float)endNum {
    float range = 0.0f;
    switch (crossTime) {
        case CrossTime1:
        {
            range = 0.3;
        }
            break;
            
        case CrossTime2:
        {
            range = 0.4;
        }
            break;
            
        case CrossTime3:
        {
            range = 0.5;
        }
            break;
            
        case CrossTime4:
        {
            range = 0.6;
        }
            break;
            
        case CrossTime6:
        {
            range = 0.7;
        }
            break;
            
        case CrossTime12:
        {
            range = 0.8;
        }
            break;
            
        case CrossTime24:
        {
            range = 0.9;
        }
            break;
            
        default:
            break;
    }
    float startT = startNum;
    float endT = endNum;
    float distanceT = endT - startT;
    NSLog(@"计算结果%f          %f          %f          %f",startT,endT,distanceT,range);
    if (fabsf(distanceT) <= range) {
        NSLog(@"YES");
        return YES;
    }else {
        NSLog(@"NO");
        return NO;
    }

}

@end
