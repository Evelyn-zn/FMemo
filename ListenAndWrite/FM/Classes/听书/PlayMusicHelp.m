//
//  PlayMusicHelp.m
//  MusicTextOne
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "PlayMusicHelp.h"
#import <AVFoundation/AVFoundation.h>

// 只限在自己文件  自己类中使用
@interface PlayMusicHelp ()

// 使用系统播放
@property (strong,nonatomic) AVPlayer *avPlayer;

@property (nonatomic,strong) NSTimer *timer;// 定时器

@end

// 单例生命周期：从创建到程序结束
@implementation PlayMusicHelp

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
- (void)playToEnd {
    // 判断block是否存在  是否有实现
    if (self.playToEndBlock) {
        self.playToEndBlock();
    }
    
}

#pragma ********** 1. 单例初始化 GCD写法 **********
static PlayMusicHelp *share = nil;

+ (PlayMusicHelp *)shareData {
    if (share == nil) {
        static dispatch_once_t haha;
        dispatch_once(&haha, ^{
            share = [[PlayMusicHelp alloc] init];
            share.avPlayer = [[AVPlayer alloc] init]; // 初始化音乐播放器
            share.avPlayer.volume = 1.0f; // 设置音量属性
            /*
            // 老师写的用来记录当前播放的歌曲下标
            share.index = -1;
             */
            share.index = 0;
            share.userDefaults = [NSUserDefaults standardUserDefaults]; // 创建
            share.userDefaultsIndex = [NSUserDefaults standardUserDefaults]; // 创建
            share.saveCurrent = 3; // 设置歌曲播放格式
            share.isPlay = NO;
            
        });
    }
    return share;
}

#pragma ********** 2. 传入音乐播放地址 **********
- (void)playMusicMP3:(NSString *)MP3URL {
    if (!MP3URL) { // 安全判断：播放地址为空的时候 直接返回
        return ;
    }
    // 移除已有的监听者
    if (self.avPlayer.currentItem) {
        [self.avPlayer.currentItem removeObserver:self forKeyPath:@"status"];
    }
    // 创建碟片
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:MP3URL]];
    // 添加监听者  监测缓存进度
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 碟片放入音乐播放器
    [self.avPlayer replaceCurrentItemWithPlayerItem:item];
}
#pragma mark ========== 监听的实现方法： 监听传值
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    // change[@"new"]:得到的是改变后的新值
    AVPlayerItemStatus status = [change[@"new"] integerValue];
    
    switch (status) {
        case AVPlayerItemStatusReadyToPlay:
#pragma 播放的总长度 除以 每一帧时间
            _sumOfTime = self.avPlayer.currentItem.duration.value / self.avPlayer.currentItem.duration.timescale;// 这个公式很重要 计算时长
            
            [self play];
            break;
            
        default:{
            NSLog(@"错误");
        }
            break;
    }
}

#pragma ********** 3. 控制播放 **********
- (void)play {
    [self.avPlayer play];
    self.isPlay = YES;
    // 定时器使用方法：
    /*
     每隔TimeInterval0.01秒调用这个方法
     */
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playTimer) userInfo:nil repeats:YES];
    }
    // 将定时器加到runloop中
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)playTimer {
    // 计算当前播放多少秒
    CGFloat timer = _avPlayer.currentTime.value/_avPlayer.currentTime.timescale;
    if (self.playTimeBlock) {
        self.playTimeBlock(timer);
    }
}



#pragma ********** 5. 暂停 **********
- (void)stop {
    [self.avPlayer pause];
    self.isPlay = NO;
    if (self.timer) {
        // 销毁定时器
        [self.timer invalidate];
        // 手动置空：
        self.timer = nil;
    }
}
#pragma ********** 6. 指定某时刻开始播放 **********
- (void)seekToTime:(CGFloat)timer {
#pragma 封装优化：
    // 寻找指定时刻前 先暂停一下
    [self stop];
    
    // timer时间内播放的进度：CMTimeMake(timer, self.avPlayer.currentTime.timescale) 第一个与第二个参数相乘
    // timer：是在0--1之间的值（一个进度条中的比例值）   timer * _sumOfTime:获取的真正的时长
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(timer * _sumOfTime, self.avPlayer.currentTime.timescale) completionHandler:^(BOOL finished) {
        // 找到指定节点 成功后 开始 播放
        if (finished) {
            [self play];
        }
    }];
}

#pragma mark    1. 重写volume的setter方法
- (void)setVolume:(CGFloat)volume {
    _avPlayer.volume = volume;
}
- (CGFloat)volume {
    return _avPlayer.volume;
}


@end
