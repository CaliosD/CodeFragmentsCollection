//
//  LDRootViewController.m
//  ThuSemMBACheckInTest
//
//  Created by Lilac on 1/26/14.
//  Copyright (c) 2014 Lilac. All rights reserved.
//

#import "LDRootViewController.h"
#import "Reachability.h"
#import "LDAppDelegate.h"

@interface LDRootViewController ()


@property (nonatomic) Reachability *internetReachability;

@end


@implementation LDRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Reachability Demo";
        ADIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0,300,60)];
        netStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 300, 20)];
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, 300, 20)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    ADIDLabel.textColor = [UIColor blackColor];
    ADIDLabel.font = [UIFont systemFontOfSize:14];
    ADIDLabel.numberOfLines = 3;
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    ADIDLabel.text = [NSString stringWithFormat:@"当前设备的IDFA为: %@",adId];
    
    [self.view addSubview:ADIDLabel];
    
    UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 65, 100, 30)];
    startBtn.backgroundColor = [UIColor redColor];
    [startBtn setTitle:@"开始定位" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [startBtn addTarget:self action:@selector(startLocationPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *stopBtn = [[UIButton alloc]initWithFrame:CGRectMake(170, 65, 100, 30)];
    stopBtn.backgroundColor = [UIColor redColor];
    [stopBtn setTitle:@"停止定位" forState:UIControlStateNormal];
    [stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [stopBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    stopBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [stopBtn addTarget:self action:@selector(stopLocationPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    
    netStatusLabel.textColor = [UIColor blackColor];
    netStatusLabel.font = [UIFont systemFontOfSize:14.f];
    netStatusLabel.text = @"当前网络连接为: ";
    [self.view addSubview:netStatusLabel];
    
    // 监控网络状况改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	[self updateInterfaceWithReachability:self.internetReachability];
    
    
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.font = [UIFont systemFontOfSize:14.f];
    timeLabel.text = @"定位时间为: ";
    [self.view addSubview:timeLabel];
}

-(void)startLocationPressed
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeMethod:) userInfo:nil repeats:YES];
}

-(void)stopLocationPressed
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Reachability whenever status changes.

- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.internetReachability)
	{
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        
        switch (netStatus) {
            case NotReachable:
                netStatusLabel.text = @"当前网络连接为: 您尚未连接到网络";
                break;
            case ReachableViaWiFi:
                netStatusLabel.text = @"当前网络连接为: WiFi已连接";
                break;
            case ReachableViaWWAN:
                netStatusLabel.text = @"当前网络连接为: WWAN已连接";
                break;
                
            default:
                break;
        }
    }

}

#pragma mark - Timer

-(void)timeMethod:(NSTimer *)timer
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [[NSDate date] timeIntervalSince1970];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];   // 大写M用来表示月份，分钟是小写m；大写S用来表示毫秒，秒是小写s;
    timeLabel.text = [NSString stringWithFormat:@"定位时间为: %@",[formatter stringFromDate:date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
}

@end
