//
//  ListenDetailViewController.m
//  FM
//
//  Created by lanou3g on 15/11/28.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "ListenDetailViewController.h"
#import "Player.h"


@interface ListenDetailViewController ()


@property (weak, nonatomic) IBOutlet UILabel *TagList;

@end

@implementation ListenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViews];
    [self playMusic];
    [self setTagList];// 设置标签
}


- (void)setViews {
    if (self.page == 0) {
        [self.albumImageView sd_setImageWithURL:[NSURL URLWithString:self.modelPro.coverSmall]];
        self.nickName.text = self.modelPro.nickname;
        self.albumName.text = self.modelPro.albumTitle;
        CGRect rect = self.introText.frame;
        rect.size.height = [self getLabelHeight:self.introText.text];
        self.introText.frame = rect;
        self.introText.text = @"简介内容甚少，请中二病患者自行脑补 ~ ~ ~ ╰(￣▽￣)╮";
        
        self.titleCurrent.text = self.modelPro.title;
    }else if (self.page == 1) {
        // 根据集合视图获取的下标 设置播放页的控件内容
        [self.albumImageView sd_setImageWithURL:[NSURL URLWithString:self.modelAL.coverMiddle]];
        self.nickName.text = self.modelAL.nickname;
        self.albumName.text = self.modelAL.title;
        CGRect rect = self.introText.frame;
        rect.size.height = [self getLabelHeight:self.introText.text];
        self.introText.frame = rect;
        self.introText.text = self.modelAL.intro;
        
        // 根据tableView下标 设置播放界面
        AlbumDetailModel *model = self.arraySecond[self.indexSecond];
        self.titleCurrent.text = model.title;
    }
}
// 播放音频：
#pragma mark ---------- 1. 播放音乐 设置图片 ----------
- (void)playMusic {
    static NSInteger current = -1;
    static NSInteger currentSecond = -1;
    if (self.page == 0) {
        if (self.index == current) {
            [EV_music play];
        }else{
            [EV_music playMusicMP3:self.modelPro.playPathAacv224];
        }
    }else {// 榜单1 2
        if (self.index == current) {// 同一个电台
            if (self.indexSecond == currentSecond) {
                
                [EV_music play];
            }else {
                AlbumDetailModel  *model = self.arraySecond[self.indexSecond];
                [EV_music playMusicMP3:model.playPathAacv164];
            }
        }else {
            // 不是同一个电台
            self.modelAL = self.arrayModel[self.index];
            AlbumDetailModel  *model = self.arraySecond[self.indexSecond];
            [EV_music playMusicMP3:model.playPathAacv164];
        }
    }
    
    current = self.index;
    currentSecond = self.indexSecond;
//    EV_music.index = self.index;
}

#pragma mark ---------- 2. 播放上一首 ----------
- (IBAction)upPlayMusic:(id)sender {
    if (self.page == 0) {
        if (self.index == 0) {
            self.index = self.arrayModel.count - 1;
        }else {
            self.index -- ;
        }
        self.modelPro = self.arrayModel[self.index];
    }else {
        if (self.indexSecond == 0) {
            self.indexSecond = self.arraySecond.count - 1;
        }else {
            self.indexSecond -- ;
        }
        self.modelDetailAL = self.arraySecond[self.indexSecond];
    }
    [self playMusic];
    [self setViews];
}
#pragma mark  3. 播放 暂停音乐
- (IBAction)playToStopMusic:(id)sender {
    if (EV_music.isPlay) {
        [self.playButton setImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
        [EV_music stop];
        
    }else {
        [self.playButton setImage:[UIImage imageNamed:@"11.png"] forState:UIControlStateNormal];
        [EV_music play];
        
    }
}

#pragma mark  4. 播放下一首
- (IBAction)downPlayMusic:(id)sender {
    if (self.page == 0) {
        if (self.index == self.arrayModel.count - 1) {
            self.index = 0;
        }else {
            self.index ++;
        }
        self.modelPro = self.arrayModel[self.index];
    }else {
        if (self.indexSecond == self.arraySecond.count - 1) {
            self.indexSecond = 0;
        }else {
            self.indexSecond ++;
        }
        self.modelDetailAL = self.arraySecond[self.indexSecond];
    }
    [self playMusic];
    [self setViews];
    
    
    
    
}

#pragma mark  5. 计算label文字高度
- (CGFloat)getLabelHeight:(NSString *)string {
    CGSize size = CGSizeMake(270, 1000);
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    
    CGRect rect =  [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}


#pragma mark  6. 设置标签
- (void)setTagList {
    CGRect rect = self.TagList.frame;// 标签Label
    DWTagList *tags = [[DWTagList alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rect) + 10, rect.origin.y, [UIScreen mainScreen].bounds.size.width - CGRectGetWidth(rect) - 20, 300.0f)];
    
    if (self.page == 0) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"这个", @"没有", @"标签", @"中二", @"骚年", @"就是", @"这么", @"傲娇", @"~(≧▽≦)/~", nil];
        [tags setTags:array];
        [self.viewScroll addSubview:tags];
    }else {
        [tags setTags:(NSArray *)self.String];
        for (NSString *str in self.String) {
            NSLog(@" ^^^^^^  %@", str);
        }
        
        
        [self.viewScroll addSubview:tags];
    }
    
    
    
    
}



















- (IBAction)backButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
