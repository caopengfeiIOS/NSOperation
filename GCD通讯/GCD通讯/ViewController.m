//
//  ViewController.m
//  GCD通讯
//
//  Created by hbgl on 17/2/27.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self downLoad];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  //栅栏模式控制多线程异步的执行顺序
    //栅栏函数不能使用全局并发队列
    
    dispatch_queue_t queen = dispatch_queue_create("com.ass", DISPATCH_QUEUE_CONCURRENT);
   
    dispatch_async(queen, ^{
        NSLog(@"download1---%@",[NSThread currentThread]);
    });
    dispatch_async(queen, ^{
        NSLog(@"download2---%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(queen, ^{
        NSLog(@"zhanlan++++++");
    });
    dispatch_async(queen, ^{
        NSLog(@"download3---%@",[NSThread currentThread]);
    });
    
    
    
    
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSLog(@"45454%@",[NSThread currentThread]);
//    });
}
-(void)delay
{
    dispatch_queue_t  queen = dispatch_queue_create_with_target("com.521.cc", DISPATCH_QUEUE_CONCURRENT, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), queen, ^{
        NSLog(@"GCD---%@",[NSThread currentThread]);
    });

}
-(void)downLoad
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //下载图片
        NSURL * url = [NSURL URLWithString:@"http://img05.tooopen.com/images/20150531/tooopen_sy_127457023651.jpg"];
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        UIImage * image = [UIImage imageWithData:imageData];
        NSLog(@"down____%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            NSLog(@"downmain____%@",[NSThread currentThread]);
        });
    });
    //更新UI

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
