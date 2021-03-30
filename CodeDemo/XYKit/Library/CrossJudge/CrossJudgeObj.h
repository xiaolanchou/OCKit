//
//  CrossJudgeObj.h
//  CodeDemo
//
//  Created by YangXiao on 2020/9/28.
//  Copyright © 2020 YangXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CrossTime1,
    CrossTime2,
    CrossTime3,
    CrossTime4,
    CrossTime6,
    CrossTime12,
    CrossTime24,
} CrossTime;

NS_ASSUME_NONNULL_BEGIN

@interface CrossJudgeObj : NSObject

+ (BOOL)isCross:(CrossTime)crossTime StartNum:(float)startNum EndNum:(float)endNum;


@end

NS_ASSUME_NONNULL_END
