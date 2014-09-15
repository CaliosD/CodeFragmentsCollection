//
//  LDShareViewController.m
//  ShareAndSend
//
//  Created by Lilac on 9/12/14.
//  Copyright (c) 2014 TZ. All rights reserved.
//

#import "LDShareViewController.h"
#import "ShareClass.h"

@interface LDShareViewController ()

@end

@implementation LDShareViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"Share All The Way";
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
    
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    msgBtn.frame = CGRectMake(20, 111+statusBarHeight, 280, 40);
    [msgBtn setTitle:NSLocalizedString(@"BTN_SHARES", nil) forState:UIControlStateNormal];
    [msgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(shareBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:msgBtn];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shareBtnPressed
{
    [ShareClass shareWithTitle:@"Here's a share message" andContent:@"So, what a sunny day! " andUrl:[NSURL URLWithString:@"www.dahzima.com"]];
}


@end
