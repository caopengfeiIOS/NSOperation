//
//  ViewController.m
//  多线程
//
//  Created by hbgl on 17/2/27.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self syncMain];
}

//****      主队列               ***//
//异步函数住队列,不会开线程
-(void)asyncMain
{
    //创建住队列
    dispatch_queue_t queen = dispatch_get_main_queue();
    dispatch_async(queen, ^{
        NSLog(@"down1====%@",[NSThread currentThread]);
    });
    dispatch_async(queen, ^{
        NSLog(@"down2====%@",[NSThread currentThread]);
    });
    dispatch_async(queen, ^{
        NSLog(@"down3====%@",[NSThread currentThread]);
    });
}
//同步函数住队列:产生死锁 主队列特点 ：如果主队列发现当前住线程有任务执行，那么住线程会暂停调用队列中的任务，直到住队列空闲为止
-(void)syncMain
{
    dispatch_queue_t  queen = dispatch_get_main_queue();
    dispatch_sync(queen, ^{
        NSLog(@"down1====%@",[NSThread currentThread]);
    });
    dispatch_sync(queen, ^{
        NSLog(@"down2====%@",[NSThread currentThread]);
    });
    dispatch_sync(queen, ^{
        NSLog(@"down3====%@",[NSThread currentThread]);
    });
}




































//***同步串行，同步并发，异步串行，异步并发  ***///
-(void)createTherd
{
    /*
     第一个参数：
     第二个参数：
     第三个参数：
     */
    NSThread * thred = [[NSThread alloc]initWithTarget:self selector:@selector(run:) object:nil];
    [thred start];
}
-(void)createTherd2
{
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:nil];
}

//异步函数和并发队列，异步才能并发，并发开启新线程
-(void)asyncConcurrent
{
    //1.创建队列
    /*
     第一个参数：c语言字符串，标识
     第二个参数：队列的类型
     */
//    dispatch_queue_t queen =  dispatch_queue_create("com.521.down", DISPATCH_QUEUE_CONCURRENT);
    //全局并发队列
    /*
     第一个参数：优先级
     第二个参数：未来使用
     第三个参数：
     */
    dispatch_queue_t queen = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.封装任务
    /*
     第一个参数：
     第二个参数：
     第三个参数：
     */
    dispatch_async(queen, ^{
        NSLog(@"thred1%@",[NSThread currentThread]);
    });
    dispatch_async(queen, ^{
        NSLog(@"thred2%@",[NSThread currentThread]);
    });
    dispatch_async(queen, ^{
        NSLog(@"thred3%@",[NSThread currentThread]);
    });
}
//异步函数，串行队列,会开线程，只开一条线程，串行执行
-(void)asyncSerial
{
 //创建队列
    dispatch_queue_t  queen = dispatch_queue_create("com.521.cc", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queen, ^{
        NSLog(@"thred%@",[NSThread currentThread]);
    });
    dispatch_async(queen, ^{
        NSLog(@"thred1%@",[NSThread currentThread]);
    });
    dispatch_async(queen, ^{
        NSLog(@"thred2%@",[NSThread currentThread]);
    });
    
}
//同步函数，并发队列,不会开线程
-(void)syncConcurrent
{
     dispatch_queue_t queen =  dispatch_queue_create("com.521.down", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queen, ^{
        NSLog(@"thred1%@",[NSThread currentThread]);
    });
    dispatch_sync(queen, ^{
        NSLog(@"thred2%@",[NSThread currentThread]);
    });
    dispatch_sync(queen, ^{
        NSLog(@"thred3%@",[NSThread currentThread]);
    });

}
//同步函数，串行队列，不开线程
-(void)syncSerail
{
    dispatch_queue_t  queen = dispatch_queue_create("com.521.cc", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queen, ^{
        NSLog(@"thred1%@",[NSThread currentThread]);
    });
    dispatch_sync(queen, ^{
        NSLog(@"thred2%@",[NSThread currentThread]);
    });
    dispatch_sync(queen, ^{
        NSLog(@"thred3%@",[NSThread currentThread]);
    });
}
-(void)run:(NSString*)param
{
    
    NSLog(@"---run---%@",[NSThread currentThread]);
}
@end
