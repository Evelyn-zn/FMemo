//
//  Player.m
//  FM
//
//  Created by lanou3g on 15/11/28.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "Player.h"

@interface Player ()
@property (strong,nonatomic) AVPlayer *avPlayer;

@end

@implementation Player
- (instancetype)init {
    if (self = [super init]) {
        _avPlayer = [[AVPlayer alloc] init];
    }
    return self;
}

- (void)playMusicMP3:(NSString *)MP3URL {
    if (!MP3URL) {
        return ;
    }
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:MP3URL]];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.avPlayer replaceCurrentItemWithPlayerItem:item];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItemStatus status = [change[@"new"] integerValue];
    switch (status) {
        case AVPlayerItemStatusReadyToPlay:
            [self.avPlayer play];
            break;
            
        default:{
            NSLog(@"错误");
        }
            break;
    }
}

//- (void)play {
//    [self.avPlayer play];
//
//}

@end
