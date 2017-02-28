//
//  ViewController.m
//  GCD迭代
//
//  Created by hbgl on 17/2/28.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIImage * _image1;
    UIImage * _image2;
}
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self apply];
    [self group3];
   //*********************************  队列组  ＊＊＊＊＊＊＊＊＊＊*************************//
}
-(void)group1
{
    //创建全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建队列组
    dispatch_group_t groun = dispatch_group_create();
    dispatch_group_async(groun, queue, ^{
        NSLog(@"1--------%@",[NSThread currentThread]);
    });
    dispatch_group_async(groun, queue, ^{
        NSLog(@"2--------%@",[NSThread currentThread]);
    });
    dispatch_group_async(groun, queue, ^{
        NSLog(@"3--------%@",[NSThread currentThread]);
        
    });
    //拦截通知，当队列中所有的任务都执行完毕的时候会进入到下面的方法
    dispatch_group_notify(groun, queue, ^{
        NSLog(@"==========dispath_notify========");
    });
    
}
-(void)group2
{
    //创建全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建队列组
    dispatch_group_t groun = dispatch_group_create();
    //3在发方法的异步任务会被纳入到队列组的监听范围，进入群组
    dispatch_group_enter(groun);
    dispatch_async(queue, ^{
        dispatch_group_leave(groun);
    });
}

-(void)group3
{
    
    //下载图片1
    dispatch_queue_t  queen = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t  group = dispatch_group_create();
    dispatch_group_async(group, queen, ^{
        NSURL * url = [NSURL URLWithString:@"http://img13.poco.cn/mypoco/myphoto/20120828/15/55689209201208281549023849547194135_001.jpg"];
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        _image1 = [UIImage imageWithData:imageData];
    });
    //2.下载图片
    dispatch_group_async(group, queen, ^{
        NSURL * url = [NSURL URLWithString:@"http://d.hiphotos.baidu.com/zhidao/pic/item/0e2442a7d933c895623a9a8fd11373f0830200f9.jpg"];
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        _image2 = [UIImage imageWithData:imageData];
        
        
    });
    

    //3.合成并显示图片
    dispatch_group_notify(group, queen, ^{
       //1.创建图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        //2.画图 1 2
        [_image1 drawInRect:CGRectMake(0, 0, 200, 100)];
        _image1 = nil;
        [_image2 drawInRect:CGRectMake(0, 100, 200, 100)];
        _image2 = nil;
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //3.根据上下文得到一张图片
        //更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backImageView.image = image;
        });
        
    });
    
    
}

















//***********************     CGD迭代               ************************//
-(void)forDemo
{
    //for循环本身是同步的
    for (int i=0; i<10; i++) {
        NSLog(@"%zd----%@",i,[NSThread currentThread]);
    }
}
//开子线程和主线程一起完成遍历任务，任务的完成时并发的
-(void)apply
{
    /*
     第一个参数：要遍历的次数
     第二个参数：队列（并发队列）
     第三个参数：index 索引
     */
//    dispatch_apply(10, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
//        NSLog(@"%zd----%@",index,[NSThread currentThread]);
//    });
    //获得原路径
    NSString * fromString = @"/Users/hbgl/Desktop/图片切图";
    //获得目标路径
    NSString * toStrinf = @"/Users/hbgl/Desktop/image";
    //获得路径下的文件
    NSArray * apth = [[NSFileManager defaultManager]subpathsAtPath:fromString];
    //拼接路径
//    NSInteger count = apth.count;
    dispatch_apply(apth.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        NSString * fullPath = [fromString stringByAppendingPathComponent:apth[index]];
        NSString * fullTo = [toStrinf stringByAppendingPathComponent:apth[index]];
        //执行剪切操作
        /*
         第一个参数：要剪切的文件路径
         第二个参数：要存放的路径
         第三个参数：错误提示
         */
        [[NSFileManager defaultManager]moveItemAtPath:fullPath toPath:fullTo error:nil];
    });
    
    
    
    
    
}

@end
