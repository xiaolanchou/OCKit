//
//  XYCallCore.h
//  CodeDemo
//
//  Created by YangXiao on 2020/8/7.
//  Copyright © 2020 YangXiao. All rights reserved.
//

#ifndef XYCallCore_h
#define XYCallCore_h

#include <stdio.h>
#include <objc/objc.h>

typedef struct {
    __unsafe_unretained Class cls;
    SEL sel;
    uint64_t time; // us (1/1000 ms)
    int depth;
} smCallRecord;

extern void smCallTraceStart();
extern void smCallTraceStop();

extern void smCallConfigMinTime(uint64_t us); //default 1000
extern void smCallConfigMaxDepth(int depth);  //default 3

extern smCallRecord *smGetCallRecords(int *num);
extern void smClearCallRecords();

#endif /* XYCallCore_h */
