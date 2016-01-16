//
//  AWCollectionViewController.m
//  FM
//
//  Created by lanou3g on 15/11/25.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "AWCollectionViewController.h"
#import "AWCollectionViewDialLayout.h"


static NSString *cellId = @"cellId";
static NSString *cellId2 = @"cellId2";
static NSString *cellId3 = @"cellId3";

@interface AWCollectionViewController ()
{
    NSMutableDictionary *thumbnailCache;
    BOOL showingSettings;
    UIView *settingsView;
    
    UILabel *radiusLabel;
    UISlider *radiusSlider;
    UILabel *angularSpacingLabel;
    UISlider *angularSpacingSlider;
    UILabel *xOffsetLabel;
    UISlider *xOffsetSlider;
    UISegmentedControl *exampleSwitch;
    AWCollectionViewDialLayout *dialLayout;
    
    // 确定cell显示的内容 xib文件
    int type;
    int index;
    
    NSMutableArray *arrayString; // 存储URL
    
}

@end

@implementation AWCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    index = 0;
    
    
    [self setViews];
    [self getData]; // 解析数据
    [self setDelegate];
    
    [self load];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark UICollectionView 上下拉刷新
- (void)load {
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    self.CollectionLayout.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.CollectionLayout reloadData];
            [weakSelf.CollectionLayout.mj_header endRefreshing];
    }];
    [self.CollectionLayout.mj_header beginRefreshing];
    
    // 上拉刷新
    self.CollectionLayout.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (index < arrayString.count) {
            [DataDetailRequest GetDetailData:arrayString[index] block:^(NSData *data, NSInteger value) {
                [self JSONData:data];
                [self.CollectionLayout reloadData];
            }];
            index ++;
        }
        [weakSelf.CollectionLayout reloadData];
        // 结束刷新
        [weakSelf.CollectionLayout.mj_footer endRefreshing];

        if (index > arrayString.count) {
            
        }
    }];
    // 默认先隐藏footer
    self.CollectionLayout.mj_footer.hidden = YES;
}


#pragma === 1 ===
- (void)setDelegate {
    self.CollectionLayout.delegate = self;
    self.CollectionLayout.dataSource = self;
}
#pragma === 2 ===
- (void)setViews {
    type = 0;
    showingSettings = NO;
    
    [self.CollectionLayout registerNib:[UINib nibWithNibName:@"dialCell1" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId];
    [self.CollectionLayout registerNib:[UINib nibWithNibName:@"dialCell2" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId2];
    [self.CollectionLayout registerNib:[UINib nibWithNibName:@"dialCell3" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId3];
    
    settingsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-44)];
    [settingsView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
    [self.view addSubview:settingsView];
    [self buildSettings];
    
    
    CGFloat radius = radiusSlider.value * 1000;
    CGFloat angularSpacing = angularSpacingSlider.value * 90;
    CGFloat xOffset = xOffsetSlider.value * 320;
    CGFloat cell_width = 240;
    CGFloat cell_height = 100;
    [radiusLabel setText:[NSString stringWithFormat:@"Radius: %i", (int)radius]];
    [angularSpacingLabel setText:[NSString stringWithFormat:@"Angular spacing: %i", (int)angularSpacing]];
    [xOffsetLabel setText:[NSString stringWithFormat:@"X offset: %i", (int)xOffset]];
    
    dialLayout = [[AWCollectionViewDialLayout alloc] initWithRadius:radius andAngularSpacing:angularSpacing andCellSize:CGSizeMake(cell_width, cell_height) andAlignment:WHEELALIGNMENTCENTER andItemHeight:cell_height andXOffset:xOffset];
    [self.CollectionLayout setCollectionViewLayout:dialLayout];
    
    [self.EditButton setTarget:self];
    [self.EditButton setAction:@selector(toggleSettingsView)];
    
    [self switchExample];
}
#pragma mark 解析数据 JSON
- (void)getData {
    // 1. URL获取：
    self.allData = [[NSMutableArray alloc] init];
    NSString *string = [self.item.key stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    
    NSString *URL = Track_URL;
    // 1. 先解析第一页数据 获取pageId值
    NSString *str = [NSString stringWithFormat:URL, self.item.contentType, string, 1];
    [DataDetailRequest GetDetailData:str block:^(NSData *data,NSInteger value) {
        [self JSONData:data];
        self.PageID = (int)value;
        arrayString = [[NSMutableArray alloc] init];
        for (int i = 2; i <= self.PageID; i++) {
            NSString *str = [NSString stringWithFormat:URL, self.item.contentType, string,i];
            [arrayString addObject:str];
        }
        [self.CollectionLayout reloadData];
    }];
}

- (void)JSONData:(NSData *)data {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:0  ];
    if (self.page == 0) {
        for (NSDictionary *diction in dic[@"list"]) {
            programModel *model = [[programModel alloc] init];
            [model setValuesForKeysWithDictionary:diction];
            [self.allData addObject:model];
        }
    }else {
        for (NSDictionary *diction in dic[@"list"]) {
            AlbumModel *model = [[AlbumModel alloc] init];
            [model setValuesForKeysWithDictionary:diction];
            [self.allData addObject:model];
        }
    }
    
}
#pragma mark 集合视图选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyA = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SecondListViewController *SecondVC = [storyA instantiateViewControllerWithIdentifier:@"SecondList_id"];
    SecondVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    
    
    UIStoryboard *storyB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ListenDetailViewController *DetailVC = [storyB instantiateViewControllerWithIdentifier:@"detail_id"];
    DetailVC.modalPresentationStyle = UIModalPresentationPopover;
    
    if (self.page == 0) {
        programModel *model = self.allData[indexPath.row];
        DetailVC.modelPro = model;
        
        DetailVC.page = self.page; // 0 1 2 直接跳转到播放界面
        
        DetailVC.arrayModel = self.allData;
        DetailVC.index = indexPath.row;
        
        [self presentViewController:DetailVC animated:YES completion:nil];
        
        
    } else {
        AlbumModel *model = self.allData[indexPath.row];
        SecondVC.modelAlB = model;
        
        
        NSArray *array = [model.tags componentsSeparatedByString:@","];
        NSString *str;
        
        if (array.count <= 1) {
        }else {
            for (int i = 0; i < array.count - 1; i++) {
                str = [array[i] stringByAppendingString:@"|"];
            }
        }
        [self.arrayTags addObjectsFromArray:array];
        
        SecondVC.arrayString = self.arrayTags;
        
        SecondVC.index = indexPath.row;
        SecondVC.allData = self.allData;
        [self presentViewController:SecondVC animated:YES completion:nil];
    }
    
    
}








-(void)buildSettings{
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"iphone_settings_view" owner:self options:nil];
    UIView *innerView = [viewArr objectAtIndex:0];
    CGRect frame = innerView.frame;
    frame.origin.y = (self.view.frame.size.height/2 - frame.size.height/2)/2;
    innerView.frame = frame;
    [settingsView addSubview:innerView];
    
    radiusLabel = (UILabel*)[innerView viewWithTag:100];
    radiusSlider = (UISlider*)[innerView viewWithTag:200];
    [radiusSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    angularSpacingLabel = (UILabel*)[innerView viewWithTag:101];
    angularSpacingSlider = (UISlider*)[innerView viewWithTag:201];
    [angularSpacingSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    xOffsetLabel = (UILabel*)[innerView viewWithTag:102];
    xOffsetSlider = (UISlider*)[innerView viewWithTag:202];
    [xOffsetSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    exampleSwitch = (UISegmentedControl*)[innerView viewWithTag:203];
    [exampleSwitch addTarget:self action:@selector(switchExample) forControlEvents:UIControlEventValueChanged];
}

-(void)switchExample{
    type = (int)exampleSwitch.selectedSegmentIndex;
    CGFloat radius = 0 ,angularSpacing  = 0, xOffset = 0;
    
    if(type == 0){
        [dialLayout setCellSize:CGSizeMake(240, 100)];
        [dialLayout setWheelType:WHEELALIGNMENTLEFT];
        
        radius = 300;
        angularSpacing = 18;
        xOffset = 70;
    }else if(type == 1){
        [dialLayout setCellSize:CGSizeMake(300, 50)];
        [dialLayout setWheelType:WHEELALIGNMENTCENTER];
        
        radius = 320;
        angularSpacing = 5;
        xOffset = 124;
    }
    
    [radiusLabel setText:[NSString stringWithFormat:@"Radius: %i", (int)radius]];
    radiusSlider.value = radius/1000;
    [dialLayout setDialRadius:radius];
    
    [angularSpacingLabel setText:[NSString stringWithFormat:@"Angular spacing: %i", (int)angularSpacing]];
    angularSpacingSlider.value = angularSpacing / 90;
    [dialLayout setAngularSpacing:angularSpacing];
    
    [xOffsetLabel setText:[NSString stringWithFormat:@"X offset: %i", (int)xOffset]];
    xOffsetSlider.value = xOffset/320;
    [dialLayout setXOffset:xOffset];
    
}

-(void)updateDialSettings{
    CGFloat radius = radiusSlider.value * 1000;
    CGFloat angularSpacing = angularSpacingSlider.value * 90;
    CGFloat xOffset = xOffsetSlider.value * 320;
    
    [radiusLabel setText:[NSString stringWithFormat:@"Radius: %i", (int)radius]];
    [dialLayout setDialRadius:radius];
    
    [angularSpacingLabel setText:[NSString stringWithFormat:@"Angular spacing: %i", (int)angularSpacing]];
    [dialLayout setAngularSpacing:angularSpacing];
    
    [xOffsetLabel setText:[NSString stringWithFormat:@"X offset: %i", (int)xOffset]];
    [dialLayout setXOffset:xOffset];
    
    [dialLayout invalidateLayout];
    [self.CollectionLayout reloadData];
}

-(void)toggleSettingsView{
    CGRect frame = settingsView.frame;
    if(showingSettings){
        // 设置编辑按钮显示状态：
        [self.EditButton setImage:[UIImage imageNamed:@"b4.png"]]; // Edit
        frame.origin.y = self.view.frame.size.height;
        type = 0;
    }else{
        [self.EditButton setImage:[UIImage imageNamed:@"b5.png"]]; // Close
        frame.origin.y = 44;
        type = 1;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        settingsView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
    showingSettings = !showingSettings;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allData.count;
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    self.arrayTags = [[NSMutableArray alloc] init];
    // 编辑按钮控制显示格式：
    if (type == 1){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId2 forIndexPath:indexPath];
        
        if (self.page == 0) {
            programModel *model = self.allData[indexPath.row];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
            titleLabel.text = model.title;
        }else {
            AlbumModel *model = self.allData[indexPath.row];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
            titleLabel.text = model.title;
        }
        return cell;
    } else if(type == 0){
        if (self.page == 0) { // 榜单1
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
            
            // 设置cell内容：
            programModel *model = self.allData[indexPath.row];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:101]; // title
            titleLabel.text = model.title;
            
            UIView *borderView = [cell viewWithTag:102]; // View边框
            borderView.layer.borderWidth = 2.5;
            borderView.layer.borderColor = [UIColor redColor].CGColor;
            
            UILabel *nameLabel = (UILabel *)[cell viewWithTag:104]; // nickname Label
            nameLabel.text = [NSString stringWithFormat:@"by:%@", model.nickname];
            
            NSString *imgURL = model.coverSmall;
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:103]; // 图片
            if(imgURL){
                [imgView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
            }
        }else { // 榜单 2 3
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId3 forIndexPath:indexPath];
            
            // 设置cell内容：
            AlbumModel *model = self.allData[indexPath.row];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:107]; // title
            titleLabel.text = model.title;
            
            UILabel *CountLabel = (UILabel *)[cell viewWithTag:109]; // title
            CountLabel.text = [NSString stringWithFormat:@"=_= %d集", model.tracksCounts];
            
            UIView *borderView = [cell viewWithTag:105]; // View边框
            borderView.layer.borderWidth = 2.5;
            borderView.layer.borderColor = [UIColor redColor].CGColor;
            
            UILabel *nameLabel = (UILabel *)[cell viewWithTag:108]; // 标签 label
            NSArray *array = [model.tags componentsSeparatedByString:@","];
            NSString *str;
            
            if (array.count <= 1) {
                nameLabel.text = [NSString stringWithFormat:@"%@",model.tags];
            }else {
                for (int i = 0; i < array.count - 1; i++) {
                    str = [array[i] stringByAppendingString:@"|"];
                }
                nameLabel.text = [NSString stringWithFormat:@"%@%@",str, array[array.count - 1]];
            }
            
            
            
            NSString *imgURL = model.coverMiddle;
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:106]; // 图片
            if(imgURL){
                [imgView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
            }
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
}


#pragma mark - UICollectionViewDelegate methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(350, 100);
}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0 , 0, 0, 0);
}

#pragma mark三方设置圆圈边框及字体颜色
/*
- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    return hexInt;
}

-(UIColor*)colorFromHex:(NSString*)hexString{
    unsigned int hexint = [self intFromHexString:hexString];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1];
    
    return color;
}
*/

- (IBAction)backButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
