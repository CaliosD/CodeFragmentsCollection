//
//  LDViewController.m
//  JSONSerializationDemo
//
//  Created by Lilac on 9/10/14.
//  Copyright (c) 2014 TZ. All rights reserved.
//

#import "LDViewController.h"

@interface LDViewController ()

@end

@implementation LDViewController
@synthesize txtView;


- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        txtView = [[UITextView alloc]initWithFrame:CGRectMake(10, 50, 300, 300)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:txtView];
    
    UIButton *jsonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [jsonButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [jsonButton setTitle:@"json解析" forState:UIControlStateNormal];
    jsonButton.frame = CGRectMake(100, 320, 120, 30);
    [jsonButton addTarget:self action:@selector(btnPressIOS5Json:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:jsonButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnPressIOS5Json:(id)sender {
    
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.weather.com.cn/data/101180601.html"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *weatherInfo = [weatherDic objectForKey:@"weatherinfo"];
    txtView.text = [NSString stringWithFormat:@"今天是 %@  %@  %@  的天气状况是：%@  %@ ",[weatherInfo objectForKey:@"date_y"],[weatherInfo objectForKey:@"week"],[weatherInfo objectForKey:@"city"], [weatherInfo objectForKey:@"weather1"], [weatherInfo objectForKey:@"temp1"]];
    NSLog(@"weatherInfo字典里面的内容为--》%@", weatherDic );
}

@end
