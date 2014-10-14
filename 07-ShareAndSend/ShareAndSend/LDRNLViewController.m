//
//  LDRNLViewController.m
//  ShareAndSend
//
//  Created by Lilac on 9/12/14.
//  Copyright (c) 2014 TZ. All rights reserved.
//

#import "LDRNLViewController.h"
#import "RegViewController.h"


@interface LDRNLViewController ()

@end

@implementation LDRNLViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Login/Register";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
    }
    
    NSLog(@"statusBarHeight:%f",statusBarHeight);
    
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(20, 111+statusBarHeight, 280, 40);
    [regBtn setTitle:NSLocalizedString(@"BTN_MOBILE_REGISTER", nil) forState:UIControlStateNormal];
    [regBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(registerUserBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:regBtn];
    
    NSArray *imagers = @[@"share_logo_weibo.png",@"share_logo_QQ.png",@"share_logo_renren.png"];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 200 + statusBarHeight, 320, 80)];
    backView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:backView];
    
    for (int i=0 ; i<3; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(45+i*(60+25),0, 60, 60)];
        [button setImage:[UIImage imageNamed:[imagers objectAtIndex:i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 101+i;
        [backView addSubview:button];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)registerUserBtnPressed
{
    RegViewController* reg=[[RegViewController alloc] init];
    [self presentViewController:reg animated:YES completion:^{
        
    }];
}

-(void)buttonPressed:(UIButton*)sender
{
    int index    = sender.tag-101;
    NSNumber *sw = [NSNumber numberWithInt:ShareTypeSinaWeibo];
    NSNumber *qs = [NSNumber numberWithInt:ShareTypeQQSpace];
    NSNumber *rr = [NSNumber numberWithInt:ShareTypeRenren];
    
    NSArray *styles = @[sw,qs,rr];
    
    
    //在授权页面中添加关注官方微博
//    [ShareSDK followUserWithType:ShareTypeSinaWeibo                    //平台类型
//                           field:@"ShareSDK"                          //关注用户的名称或ID
//                       fieldType:SSUserFieldTypeName      //字段类型，用于指定第二个参数是名称还是ID
//                     authOptions:nil                     //授权选项
//                    viewDelegate:nil                    //授权视图委托
//                          result:^(SSResponseState state, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {               //返回回调
//                              NSString *msg = nil;
//                              if (state == SSResponseStateSuccess)
//                              {
//                                  NSLog(@"关注成功");
//                              }
//                              else if (state == SSResponseStateFail)
//                              {
//                                  NSLog(@"%@", [NSString stringWithFormat:@"关注失败:%@", error.errorDescription]);
//                              }
//                          }];

    [ShareSDK getUserInfoWithType:[styles[index] intValue]
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               NSLog(@"~~~%@",[userInfo nickname]);
                               
                               if (result) {
//                                   LGModelData *loginData = [LGModelData shareDataOfLogin];
//                                   loginData.nickName = [userInfo nickname];
//                                   
//                                   self.valueBlock(loginData);
                                   
                               }else {
                                   NSLog(@"error description: %@",[error errorDescription]);
                               }
                               
                           }];
}

@end
