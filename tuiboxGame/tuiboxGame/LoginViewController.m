//
//  LoginViewController.m
//  douaiGame
//
//  Created by douaiwan on 2023/4/27.
//

#import "LoginViewController.h"
#import "TBMenuViewController.h"
#import "AgreementViewController.h"
#import "TBUserInfo.h"
#import "HJNetwork.h"
#import "GTMBase64.h"
#import "AFNetworking.h"
#import "CSConfirmAlertView.h"

//登录
static NSString *KLogin = @"YXBpL1Bob25lL3Bob25lX2xvZ2lu";
//发送验证码
static NSString *KSendSMS = @"YXBpL1NlbmRzbXMvaW5kZXg=";
//注册
static NSString *KRegist = @"YXBpL1Bob25lL3Bob25lX3JlZw==";
//验证码登录
static NSString *KSMSLogin = @"YXBpL1Bob25lL3Bob25lX2xvZ2lu";
//baseURL
#define KBASEURL @"aHR0cDovL3hpYW95YW9fdGVzdC5zc2NoZS5jbi8="


@interface LoginViewController ()<UITextFieldDelegate,CSConfirmAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *SMSLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *PWLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIView *pwView;
@property (weak, nonatomic) IBOutlet UITextField *pwViewPhoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *pwViewPhonetipLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwViewPWTextField;
@property (weak, nonatomic) IBOutlet UILabel *pwViewPWtipLabel;
@property (weak, nonatomic) IBOutlet UIView *smsCodeView;
@property (weak, nonatomic) IBOutlet UIView *registPWView;
@property (weak, nonatomic) IBOutlet UIButton *findPWButton;
@property (weak, nonatomic) IBOutlet UIView *pwPWView;
@property (weak, nonatomic) IBOutlet UIButton *smsBtn;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *smsCodetipLabel;
@property (weak, nonatomic) IBOutlet UITextField *registerViewPWTextField;
@property (weak, nonatomic) IBOutlet UILabel *registerPWtipLabel;

@property (weak, nonatomic) IBOutlet UIButton *agremetBtn;
@property (weak, nonatomic) IBOutlet UIImageView *agreeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *pwLoginButtonImageView;
@property (weak, nonatomic) IBOutlet UIImageView *smsLoginButtonImageView;
@property (weak, nonatomic) IBOutlet UIImageView *registButtonImageView;

@property (weak, nonatomic) IBOutlet UIImageView *loginBgImageViewOne;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.pageType = TBLoginPageTypeLogin;

}

- (IBAction)backHomeClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)smsLoginClick:(UIButton *)sender {
    self.pageType = TBLoginPageTypeSmsLogin;
    self.registPWView.hidden = YES;
    self.smsCodeView.hidden = NO;
    self.pwPWView.hidden = YES;
    self.pwViewPhonetipLabel.text = @"输入手机号";
    [self.smsLoginButtonImageView setImage:[UIImage imageNamed:@"短信登录点击"]];
    [self.pwLoginButtonImageView setImage:[UIImage imageNamed:@"密码登录未点击"]];
    [self.registButtonImageView setImage:[UIImage imageNamed:@"注册未点击"]];
    [self.loginButton setImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
}
- (IBAction)pwLoginClick:(UIButton *)sender {
    self.pageType = TBLoginPageTypeLogin;
    self.registPWView.hidden = YES;
    self.smsCodeView.hidden = YES;
    self.pwPWView.hidden = NO;
    self.pwViewPhonetipLabel.text = @"输入账号";
    [self.smsLoginButtonImageView setImage:[UIImage imageNamed:@"短信登录未点击"]];
    [self.pwLoginButtonImageView setImage:[UIImage imageNamed:@"密码登录点击"]];
    [self.registButtonImageView setImage:[UIImage imageNamed:@"注册未点击"]];
    [self.loginButton setImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
}
- (IBAction)registerClick:(UIButton *)sender {
    self.pageType = TBLoginPageTypeRegist;
    self.registPWView.hidden = NO;
    self.smsCodeView.hidden = NO;
    self.pwPWView.hidden = YES;
    self.pwViewPhonetipLabel.text = @"输入手机号";
    [self.smsLoginButtonImageView setImage:[UIImage imageNamed:@"短信登录未点击"]];
    [self.pwLoginButtonImageView setImage:[UIImage imageNamed:@"密码登录未点击"]];
    [self.registButtonImageView setImage:[UIImage imageNamed:@"注册点击"]];
    [self.loginButton setImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
}

- (IBAction)gameLoginClick:(id)sender {
    switch (self.pageType) {
        case TBLoginPageTypeLogin:
        {
            if (self.pwViewPhoneTextField.text.length != 11) {
                [Toast ShowCenterWithText:@"请输入手机号"];
                return;
            }
            if(self.pwViewPWTextField.text.length <= 0) {
                [Toast ShowCenterWithText:@"密码不能为空"];
                return;
            }
            if(self.pwViewPWTextField.text.length < 6) {
                [Toast ShowCenterWithText:@"密码至少6位"];
                return;
            }
            if(!_agremetBtn.selected) {
                [Toast ShowCenterWithText:@"请阅读并同意下面协议"];
                return;
            }
            NSDictionary *dic;
            NSString *url;
            
            dic = @{@"mobile":self.pwViewPhoneTextField.text,@"para":self.pwViewPWTextField.text,@"type":@"0"};
            url = KLogin;
            [HJNetwork setBaseURL:[GTMBase64 decodeBase64String:KBASEURL]];
            
            [HJNetwork POSTWithURL:[GTMBase64 decodeBase64String:url] parameters:dic cachePolicy:HJCachePolicyIgnoreCache callback:^(id responseObject, BOOL isCache, NSError *error) {
                NSInteger code = [responseObject[@"code"] integerValue];
                if(error){
                    if([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
                        id response = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
                        NSError *newError;
                        if (response) {
                            if([response isKindOfClass:[NSData class]]){
                                NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                                NSMutableDictionary *userinfo = error.userInfo.mutableCopy;
                                if (data) {
                                    [userinfo setObject:data forKey:@"response"];
                                    newError = [NSError errorWithDomain:error.domain code:error.code userInfo:userinfo];
                                    [Toast ShowCenterWithText:newError.description];
                                }
                            }else {
                                NSDictionary *dict = response;
                                [Toast ShowCenterWithText:dict[@"error"]];
                            }
                        }
                       
                    }else {
                        [Toast ShowCenterWithText:error.description];
                    }
                }else {
                    if(code != 200){
                        [Toast ShowCenterWithText:responseObject[@"msg"]];
                    }else {
                        [Toast ShowCenterWithText:@"登录成功"];
                        [TBUserManager saveUserInfo:responseObject[@"data"]];
                        [self.navigationController pushViewController:[[TBMenuViewController alloc] init] animated:YES];
                    }
                }
             
            }];
        }break;
        case  TBLoginPageTypeRegist:
        {
             if (self.pwViewPhoneTextField.text.length != 11) {
                 [Toast ShowCenterWithText:@"请输入手机号"];
                 return;
             }
            if(self.smsCodeTextField.text.length <= 0) {
                [Toast ShowCenterWithText:@"请输入验证码"];
                return;
            }
            if(self.registerViewPWTextField.text.length < 6) {
                [Toast ShowCenterWithText:@"密码至少6位"];
                return;
            }
            if(!_agremetBtn.selected) {
                [Toast ShowCenterWithText:@"请阅读并同意下面协议"];
                return;
            }
            NSDictionary *dic;
            NSString *url;
            
            dic = @{@"mobile":self.pwViewPhoneTextField.text,@"code":self.smsCodeTextField.text,@"password":self.registerViewPWTextField.text};
            url = KRegist;
            [HJNetwork setBaseURL:[GTMBase64 decodeBase64String:KBASEURL]];
            
            [HJNetwork POSTWithURL:[GTMBase64 decodeBase64String:url] parameters:dic cachePolicy:HJCachePolicyIgnoreCache callback:^(id responseObject, BOOL isCache, NSError *error) {
                NSInteger code = [responseObject[@"code"] integerValue];
                if(error){
                    if([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
                        id response = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
                        NSError *newError;
                        if (response) {
                            if([response isKindOfClass:[NSData class]]){
                                NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                                NSMutableDictionary *userinfo = error.userInfo.mutableCopy;
                                if (data) {
                                    [userinfo setObject:data forKey:@"response"];
                                    newError = [NSError errorWithDomain:error.domain code:error.code userInfo:userinfo];
                                    [Toast ShowCenterWithText:newError.description];
                                }
                            }else {
                                NSDictionary *dict = response;
                                [Toast ShowCenterWithText:dict[@"error"]];
                            }
                        }
                        
                    }else {
                        [Toast ShowCenterWithText:error.description];
                    }
                }else {
                    if(code == 200){
                        [Toast ShowCenterWithText:@"注册成功"];
                        self.pageType = TBLoginPageTypeLogin;
                        [self pwLoginClick:nil];
                    }else {[Toast ShowCenterWithText:responseObject[@"msg"]];}
                }
             
            }];
        } break;
        case  TBLoginPageTypeSmsLogin:
        {
            
            if (self.pwViewPhoneTextField.text.length != 11) {
                [Toast ShowCenterWithText:@"请输入手机号"];
                return;
            }
           if(self.smsCodeTextField.text.length <= 0) {
               [Toast ShowCenterWithText:@"请输入验证码"];
               return;
           }
            if(!_agremetBtn.selected) {
                [Toast ShowCenterWithText:@"请阅读并同意下面协议"];
                return;
            }
            
            NSDictionary *dic;
            NSString *url;
           
            dic = @{@"mobile":self.pwViewPhoneTextField.text,@"para":self.smsCodeTextField.text,@"type":@"1"};
            url = KSMSLogin;
            [HJNetwork setBaseURL:[GTMBase64 decodeBase64String:KBASEURL]];
            
            [HJNetwork POSTWithURL:[GTMBase64 decodeBase64String:url] parameters:dic cachePolicy:HJCachePolicyIgnoreCache callback:^(id responseObject, BOOL isCache, NSError *error) {
                
                if(error){
                    if([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
                        id response = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
                        NSError *newError;
                        if (response) {
                            if([response isKindOfClass:[NSData class]]){
                                NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                                NSMutableDictionary *userinfo = error.userInfo.mutableCopy;
                                if (data) {
                                    [userinfo setObject:data forKey:@"response"];
                                    newError = [NSError errorWithDomain:error.domain code:error.code userInfo:userinfo];
                                    [Toast ShowCenterWithText:newError.description];
                                }
                            }else {
                                NSDictionary *dict = response;
                                [Toast ShowCenterWithText:dict[@"error"]];
                            }
                        }
                        
                    }else {
                        [Toast ShowCenterWithText:error.description];
                    }
                }else {
                    NSInteger code = [responseObject[@"code"] integerValue];
                    if(code == 200) {
                        [TBUserManager saveUserInfo:responseObject[@"data"]];
                        [self.navigationController pushViewController:[[TBMenuViewController alloc] init] animated:YES];
                    }else {
                        [Toast ShowCenterWithText:@"手机号或者验证码不正确"];
                    }
                }
            }];
        }
            break;
            
        default:
            break;
    }
}
- (IBAction)userAgreementClick:(id)sender {
    AgreementViewController *webView = [[AgreementViewController alloc] init];
    webView.webUrlString = @"http://pg.pk66.cn/ylxyyh.html";
    webView.agreementNameStr = @"用户协议";
    [self.navigationController pushViewController:webView animated:YES];
    
}
- (IBAction)privacyAgreementClick:(id)sender {
    AgreementViewController *webView = [[AgreementViewController alloc] init];
    webView.webUrlString = @"http://pg.pk66.cn/ylxyys.html";
    webView.agreementNameStr = @"隐私协议";
    [self.navigationController pushViewController:webView animated:YES];
}

- (IBAction)goGameEntranceViewClick:(id)sender {
    
    [CSConfirmAlertView showConfirm:@"选择游客身份将不会存储您的任何信息以及游戏进度，您确定要进入吗？" withDelegate:self atView:nil withTag:100002 withTitle:@"提示"];
}


- (IBAction)getSMSCodeClick:(UIButton *)sender {
    NSLog(@"获取验证码");

    if (self.pwViewPhoneTextField.text.length != 11) {
        [Toast ShowCenterWithText:@"请输入手机号"];
        return;
    }
    NSInteger type = self.pageType == TBLoginPageTypeRegist ? 1:2;
    NSDictionary *dic;
    NSString *url;
    dic = @{@"phone_number":self.pwViewPhoneTextField.text,@"type":[@(type)stringValue]};
    url = KSendSMS;
    [HJNetwork setBaseURL:[GTMBase64 decodeBase64String:KBASEURL]];
    if(!_agremetBtn.selected) {
        [Toast ShowCenterWithText:@"请阅读并同意下面协议"];
        return;
    }
    [HJNetwork POSTWithURL:[GTMBase64 decodeBase64String:url] parameters:dic cachePolicy:HJCachePolicyIgnoreCache callback:^(id responseObject, BOOL isCache, NSError *error) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if(error){
            if([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
                id response = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
                NSError *newError;
                if (response) {
                    if([response isKindOfClass:[NSData class]]){
                        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                        NSMutableDictionary *userinfo = error.userInfo.mutableCopy;
                        if (data) {
                            [userinfo setObject:data forKey:@"response"];
                            newError = [NSError errorWithDomain:error.domain code:error.code userInfo:userinfo];
                            [Toast ShowCenterWithText:newError.description];
                        }
                    }else {
                        NSDictionary *dict = response;
                        [Toast ShowCenterWithText:dict[@"error"]];
                    }
                }
                
            }else {
                [Toast ShowCenterWithText:error.description];
            }
        }else {
            if(code == 200){
                [Toast ShowCenterWithText:@"发送成功"];
            }else {
                NSString *msgStr = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                [Toast ShowCenterWithText:msgStr];
            }
        }
    }];
}

- (IBAction)aggreXieyiClick:(UIButton *)sender {
   self.agreeImageView.hidden = !self.agreeImageView.hidden;
    _agremetBtn.selected = !_agremetBtn.selected;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 10001:
            self.pwViewPhonetipLabel.hidden = YES;
            break;
        case 10002:
            self.pwViewPWtipLabel.hidden = YES;
            break;
        case 10003:
            self.smsCodetipLabel.hidden = YES;
            break;
        case 10004:
            self.registerPWtipLabel.hidden = YES;
            break;
        default:
            break;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 10001:
            if (textField.text.length==0) {
                self.pwViewPhonetipLabel.hidden = NO;
            }
            break;
        case 10002:
            if (textField.text.length==0) {
                self.pwViewPWtipLabel.hidden = NO;
            }
            break;
        case 10003:
            if (textField.text.length==0) {
                self.smsCodetipLabel.hidden = NO;
            }
            break;
        case 10004:
            if (textField.text.length==0) {
                self.registerPWtipLabel.hidden = NO;
            }
            break;
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark TBConfirmAlertViewDelegate
- (void) confirmAlertViewYesPressed:(CSConfirmAlertView *)alertview
{
    NSLog(@"弹框代理yes");
    if (alertview.tag == 100002) {
        [self.navigationController pushViewController:[[TBMenuViewController alloc] init] animated:YES];
    }
}

- (void) confirmAlertViewCancelPressed:(CSConfirmAlertView *)alertview
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
