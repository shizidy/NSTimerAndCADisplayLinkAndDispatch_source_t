//
//  ViewController.m
//  NSTimerAndCADisplayLinkAndDispatch_source_t
//
//  Created by Macmini on 2019/8/19.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) dispatch_source_t sourceTimer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTimer];
    [self setupDisplayLink];
    [self setupSourceTimer];
    // Do any additional setup after loading the view.
}

- (void)setupTimer {
    //自动加入NSRunLoop
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
    
    //手动加入NSRunLoop
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
    //设置NSDefaultRunLoopMode时，timer会有不准确的情况，当屏幕接受用户交互时，例如滑动scrollView屏幕,timer将不回调
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    //设置NSRunLoopCommonModes timer才不会因为主线程runloop执行耗时操作而停止回调
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    //启动timer
    [self.timer setFireDate:[NSDate distantPast]];
    //销毁定时器
    //[_timer invalidate];
    //_timer = nil;
}

- (void)timerHandler:(NSTimer *)timer {
    NSLog(@"NSTimer回调");
}

- (void)setupDisplayLink {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkHandler:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //销毁定时器
    //[_displayLink invalidate];
    //_displayLink = nil;
}

- (void)displayLinkHandler:(CADisplayLink *)displayLink {
    NSLog(@"DisplayLink回调");
}

- (void)setupSourceTimer {
    self.sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    //时间间隔
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    //开始
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    //设置timer
    dispatch_source_set_timer(self.sourceTimer, start, interval, 0);
    //设置回调
    dispatch_source_set_event_handler(self.sourceTimer, ^{
        //
    });
    
//    //取消timer
//    dispatch_cancel(_sourceTimer);
//    _sourceTimer = nil;
}

@end
