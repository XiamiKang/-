//
//  ViewController.m
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/8.
//

#import "ViewController.h"
#import "CSConfirmAlertView.h"
#import "TBMenuViewController.h"
#import "LoginViewController.h"
#import "TBUserInfo.h"
#import "RankTableViewCell.h"
#import "TBSound.h"
#import <AVFAudio/AVFAudio.h>
#import "HJNetwork.h"
#import "GTMBase64.h"
#import "AudioManage.h"

@interface ViewController ()<CSConfirmAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *mobanView;
@property (weak, nonatomic) IBOutlet UIView *rankView;
@property (weak, nonatomic) IBOutlet UITableView *rankTableView;
@property (nonatomic, strong) NSArray *nameArray;
@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UISlider *soundSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [AudioManage playMusic:@"game_music.mp3"];
    
    self.nameArray = @[@"真好玩",@"底单空",@"UN无额",@"薮猫才",@"U盾苏快上岛咖啡",@"苏不到",@"呼声不擅长"];
    [self.rankTableView registerNib:[UINib nibWithNibName:@"RankTableViewCell" bundle:nil] forCellReuseIdentifier:@"RankTableViewCell"];
    
}

- (IBAction)settingClick:(id)sender {
    self.mobanView.hidden = NO;
    self.settingView.hidden = NO;
}

- (IBAction)closeSettingViewClick:(id)sender {
    self.mobanView.hidden = YES;
    self.settingView.hidden = YES;
}
- (IBAction)zhuxiaoClick:(id)sender {
    TBUserInfo *userInfo = [TBUserManager userInfo];
    if(!kISNullString(userInfo.token) || !kISNullString(userInfo.unionid)){
        self.mobanView.hidden = YES;
        self.settingView.hidden = YES;
        [CSConfirmAlertView showConfirm:@"注销后，您将无法使用当前账号,该账号的相关数据也将被删除,无法找回" withDelegate:self atView:nil withTag:100004 withTitle:@"提示"];
    }else {
        [Toast ShowCenterWithText:@"您未登录账号"];
    }
}
- (IBAction)tuichuClick:(id)sender {
    TBUserInfo *userInfo = [TBUserManager userInfo];
    if(!kISNullString(userInfo.token) || !kISNullString(userInfo.unionid)){
        self.mobanView.hidden = YES;
        self.settingView.hidden = YES;
        [CSConfirmAlertView showConfirm:@"您确定要退出登录吗" withDelegate:self atView:nil withTag:100005 withTitle:@"提示"];
    }else {
        [Toast ShowCenterWithText:@"您未登录账号"];
    }
}
- (IBAction)sliderValueChanged:(UISlider *)sender {
    NSLog(@"-----%f",sender.value);
    if (sender.value<0.3) {
        [AudioManage stopMusic:@"game_music.mp3"];
    } else if(sender.value>0.5){
        [AudioManage playMusic:@"game_music.mp3"];
    }
}


- (IBAction)ranking:(id)sender {
    self.mobanView.hidden = NO;
    self.rankView.hidden = NO;
}
- (IBAction)closeRankViewClick:(id)sender {
    self.mobanView.hidden = YES;
    self.rankView.hidden = YES;
}

- (IBAction)playClick:(id)sender {
    TBUserInfo *userInfo = [TBUserManager userInfo];
    if(!kISNullString(userInfo.token) || !kISNullString(userInfo.unionid)){
        [self.navigationController pushViewController:[[TBMenuViewController alloc]init] animated:YES];
    }else {
        [CSConfirmAlertView showConfirm:@"您还没有登录，马上进入登录界面" withDelegate:self atView:nil withTag:100003 withTitle:@"提示"];
    }
}
- (IBAction)tryPlayClick:(id)sender {
    [CSConfirmAlertView showConfirm:@"选择游客身份将不会存储您的任何信息以及游戏进度，您确定要进入吗？" withDelegate:self atView:nil withTag:100002 withTitle:@"提示"];
    
}

#pragma mark -
#pragma mark TBConfirmAlertViewDelegate
- (void) confirmAlertViewYesPressed:(CSConfirmAlertView *)alertview
{
    NSLog(@"弹框代理yes");
    if (alertview.tag == 100002) {
        [self.navigationController pushViewController:[[TBMenuViewController alloc] init] animated:YES];
    }
    if (alertview.tag == 100003) {
        [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
    }
    if (alertview.tag == 100004) {
        TBUserInfo *userInfo = [TBUserManager userInfo];
        NSString *token = @"";
        if(kISNullString(userInfo.token)) {
            token = userInfo.unionid;
        }else {
            token = userInfo.token;
        }
        [HJNetwork POSTWithURL:[GTMBase64 decodeBase64String:@"YXBpL3VzZXIvZGVsVXNlcg=="] parameters:@{@"token":token} headers:@{} cachePolicy:HJCachePolicyIgnoreCache callback:^(id responseObject, BOOL isCache, NSError *error) {
            NSInteger code =  [responseObject[@"code"] integerValue];
            if(code == 200){
                [Toast ShowCenterWithText:@"注销成功"];
                [TBUserManager clearUserInfo];
            }else {
                [Toast ShowCenterWithText:@"网络错误,请稍后再试"];
            }
        }];
    }
    if (alertview.tag == 100005) {
        [TBUserManager clearUserInfo];
    }
    
}

- (void) confirmAlertViewCancelPressed:(CSConfirmAlertView *)alertview
{
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell;
    
    RankTableViewCell *rankCell = [tableView dequeueReusableCellWithIdentifier:@"RankTableViewCell" forIndexPath:indexPath];
    if (rankCell != nil) {
        [rankCell removeFromSuperview];//处理重用
    }
    if(indexPath.row < 3) {
        rankCell.rankNumLabel.text = @"";
        rankCell.rankUserNameLabel.text = @"";
        rankCell.rankSorceLabel.text = @"";
        [rankCell.rankBgImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row+1]]];
    }else {
        rankCell.rankNumLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        rankCell.rankUserNameLabel.text = [NSString stringWithFormat:@"%@",self.nameArray[indexPath.row-3]];
        rankCell.rankSorceLabel.text = [NSString stringWithFormat:@"%ld",180-indexPath.row];
        [rankCell.rankBgImage setImage:[UIImage imageNamed:@"4"]];
    }
    
    return rankCell;
    
}

@end
