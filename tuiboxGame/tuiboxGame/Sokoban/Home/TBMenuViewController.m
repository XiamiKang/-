//
//  TBMenuViewController.m
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/8.
//

#import "TBMenuViewController.h"
#import "TBBoxLevelButton.h"
#import "TBGmaeViewController.h"
#import "ViewController.h"

//关卡列表中button的间隔
#define LEVELINTERVALWIDTH   YFSCREENWIDTH/17.5

@interface TBMenuViewController ()

@end

@implementation TBMenuViewController

@synthesize boxMapScrollView;
@synthesize pageControl;
@synthesize soundButton;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (int i = 0; i <= [[TBLevelManage sharedInstance] currentLevel]; i ++)
    {
        TBBoxLevelButton *btn = [buttonArray objectAtIndex:i];
        TBLevelItem *it = [[TBLevelManage sharedInstance] levelItemAtIndex:i];
        [btn updateWithLevelItem:it];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    buttonArray = [[NSMutableArray alloc] init];
    int x_offset = LEVELINTERVALWIDTH;
    int y_offset = LEVELINTERVALWIDTH;
    
    
    
    for (int i = 0; i < [[TBLevelManage sharedInstance] totalLevel]; i++)
    {
        TBLevelItem *item = [[TBLevelManage sharedInstance] levelItemAtIndex:i];
        int page = floor( i / AMOUNT_PER_PAGE) + 1;
        int row = ceil((i % AMOUNT_PER_PAGE)/ AMOUNT_PER_COLUMN) + 1;
        int col = ceil((i % AMOUNT_PER_PAGE) % AMOUNT_PER_COLUMN)+1;
        CGRect itemRect = CGRectMake((page - 1)*YFSCREENWIDTH + x_offset*col + (col - 1)*BOX_MENU_BUTTON_WIDTH,
                                     y_offset*row + (row - 1)*BOX_MENU_BUTTON_HEIGHT,
                                     BOX_MENU_BUTTON_WIDTH, BOX_MENU_BUTTON_HEIGHT);
        
        
        TBBoxLevelButton *btn = [[TBBoxLevelButton alloc] initWithFrame:itemRect];
        [btn updateWithLevelItem:item];
        [boxMapScrollView addSubview:btn];
        [btn setTag:i];
        [btn addTarget:self action:@selector(responseToLevelButton:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:btn];
    }
    
    boxMapScrollView.frame = CGRectMake(0, YFSCREENHEIGHT*0.2, YFSCREENWIDTH, YFSCREENHEIGHT*0.6);
    int pageNum = ceil([[TBLevelManage sharedInstance] totalLevel] / (AMOUNT_PER_PAGE*1.0) );
    CGSize scrollSize = CGSizeMake(YFSCREENWIDTH*pageNum, 0);
    [boxMapScrollView setContentSize:scrollSize];
    [boxMapScrollView setPagingEnabled:YES];
    [boxMapScrollView setShowsHorizontalScrollIndicator:NO];
    
    int currentPage = [[TBLevelManage sharedInstance] currentLevel] / AMOUNT_PER_PAGE ;
    int xo = currentPage * boxMapScrollView.frame.size.width;
    [boxMapScrollView setContentOffset:CGPointMake(xo, 0)];
    
    self.pageControl.frame = CGRectMake(0, YFSCREENHEIGHT*0.2+YFSCREENHEIGHT*0.6+10, YFSCREENWIDTH, 30);
    [self.pageControl setNumberOfPages:pageNum];
    [self.pageControl setCurrentPage:currentPage];
    
    [self updateSoundButton];
}


- (void)responseToLevelButton:(id)sender
{
    [[TBSound sharedInstance] playSound:TBSoundType_KEY];
    UIButton* btn = (UIButton*)sender;
    int level  = (int)[btn tag];
    TBGmaeViewController *boxController = [[TBGmaeViewController alloc] initWithLevel:level+1];
    [self.navigationController pushViewController:boxController animated:NO];
}

- (IBAction)onVoice:(id)sender
{
    if ([[TBSound sharedInstance] isOn])
    {
        [[TBSound sharedInstance] setON:NO];
    }else
    {
        [[TBSound sharedInstance] setON:YES];
    }
    [[TBSound sharedInstance] playSound:TBSoundType_KEY];
    [self updateSoundButton];
}


- (void)updateSoundButton
{
    
    if ([[TBSound sharedInstance] isOn])
    {
        
        UIImage* onImg = [UIImage imageNamed:@"按钮4"];
        [soundButton setImage:onImg forState:UIControlStateNormal];
    }else
    {
        UIImage* offImg = [UIImage imageNamed:@"关闭音量"];
        [soundButton setImage:offImg forState:UIControlStateNormal];
    }
}

#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = boxMapScrollView.frame.size.width;
    int page = floor((boxMapScrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    [pageControl setCurrentPage:page];
}


#pragma mark SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backVIewClick:(id)sender {
    //返回到View
    for (UIViewController *controller in self.navigationController.viewControllers) {
         BOOL isKindOfClass = [controller isKindOfClass:[ViewController class]];
         if (isKindOfClass) {
             [self.navigationController popToViewController:controller animated:YES];
           }
      }

}


@end
