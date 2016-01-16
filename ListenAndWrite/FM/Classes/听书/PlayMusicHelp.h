//
//  PlayMusicHelp.h
//  MusicTextOne
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EV_shareMusicPlay [PlayMusicHelp shareData]

@interface PlayMusicHelp : NSObject
#pragma 1. 单例初始化 GCD写法
+ (PlayMusicHelp *)shareData;

#pragma 2. 传入音乐播放地址
- (void)playMusicMP3:(NSString *)MP3URL;

#pragma 3. 控制播放
- (void)play;

#pragma 4. 获取当前播放音乐的总时长
@property (assign,nonatomic) CGFloat sumOfTime;

#pragma 5. 暂停
- (void)stop;

#pragma 6. 指定某时刻开始播放
- (void)seekToTime:(CGFloat)timer;


// 播放状态
@property (nonatomic,assign) BOOL isPlay;
// 播放完成回调 用copy将block从堆区拷贝到栈区使用
@property (copy,nonatomic) void (^playToEndBlock)();

// 0.1 秒回调block
@property (copy,nonatomic) void(^playTimeBlock)(CGFloat);

// 音量
@property (assign,nonatomic) CGFloat volume;

//@property (assign,nonatomic) TimeValue currentTime;

@property (assign,nonatomic) NSInteger index;

@property (strong,nonatomic) NSUserDefaults *userDefaults; // 轻量级存储

#pragma mark 自己添加的属性

@property (strong,nonatomic) NSUserDefaults *userDefaultsIndex; // 轻量级存储
@property (assign,nonatomic) int saveCurrent; // 保存播放类型的状态
@end
