//
//  AgreementViewController.m
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/12.
//

#import "AgreementViewController.h"
#import <WebKit/WebKit.h>

@interface AgreementViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *agreementTitleLabel;


@end

@implementation AgreementViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.agreementTitleLabel.text = self.agreementNameStr;
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-104)];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    [self.view  addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrlString]]];
    
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
