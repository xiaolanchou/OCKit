//
//  AppDelegate.m
//  CodeDemo
//
//  Created by YangXiao on 2020/8/7.
//  Copyright © 2020 YangXiao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LSViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self testBarrier];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    void (^blockTest)(void) = ^{
        NSLog(@"block测试");
    };
    NSLog(@"%@",blockTest);
    
    //    self.window.rootViewController = [[ViewController alloc] init];;
    self.window.rootViewController = [[LSViewController alloc] init];;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)testBarrier{
    /*
     dispatch_barrier_sync & dispatch_barrier_async
     
     应用场景：同步锁
     
     等栅栏前追加到队列中的任务执行完毕后，再将栅栏后的任务追加到队列中。
     简而言之，就是先执行栅栏前任务，再执行栅栏任务，最后执行栅栏后任务
     
     - dispatch_barrier_async：前面的任务执行完毕才会来到这里
     - dispatch_barrier_sync：作用相同，但是这个会堵塞线程，影响后面的任务执行
    
     - dispatch_barrier_async可以控制队列中任务的执行顺序，
     - 而dispatch_barrier_sync不仅阻塞了队列的执行，也阻塞了线程的执行（尽量少用）
     */
    
    [self testBarrier1];
    [self testBarrier2];
}
- (void)testBarrier1{
    //串行队列使用栅栏函数
    
    dispatch_queue_t queue = dispatch_queue_create("CJL", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"开始 - %@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"延迟2s的任务1 - %@", [NSThread currentThread]);
    });
    NSLog(@"第一次结束 - %@", [NSThread currentThread]);
    
    //栅栏函数的作用是将队列中的任务进行分组，所以我们只要关注任务1、任务2
    dispatch_barrier_async(queue, ^{
        NSLog(@"------------栅栏任务------------%@", [NSThread currentThread]);
    });
    NSLog(@"栅栏结束 - %@", [NSThread currentThread]);
    
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"延迟2s的任务2 - %@", [NSThread currentThread]);
    });
    NSLog(@"第二次结束 - %@", [NSThread currentThread]);
}
- (void)testBarrier2{
    //并发队列使用栅栏函数
    
    dispatch_queue_t queue = dispatch_queue_create("CJL", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"开始 - %@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"延迟2s的任务1 - %@", [NSThread currentThread]);
    });
    NSLog(@"第一次结束 - %@", [NSThread currentThread]);
    
    //由于并发队列异步执行任务是乱序执行完毕的，所以使用栅栏函数可以很好的控制队列内任务执行的顺序
    dispatch_barrier_async(queue, ^{
        NSLog(@"------------栅栏任务------------%@", [NSThread currentThread]);
    });
    NSLog(@"栅栏结束 - %@", [NSThread currentThread]);
    
    dispatch_async(queue, ^{
        sleep(2);
        NSLog(@"延迟2s的任务2 - %@", [NSThread currentThread]);
    });
    NSLog(@"第二次结束 - %@", [NSThread currentThread]);
}



#pragma mark - UISceneSession lifecycle



@end
