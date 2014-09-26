- Reachability的Github：https://github.com/tonymillion/Reachability.
- 支持Cocoapod.

- 如果使用AFNetworking（>=2.4.0）中的AFNetworkReachabilityManager来实现此功能也是类似的。

```smalltalk
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    ……
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:_AFNetworkingReachabilityDidChangeNotification_ object:nil];
    self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [self.reachabilityManager startMonitoring];
    ……
}

- (void)reachabilityChanged: (NSNotification *)note
{
    /*
    `AFNetworkingReachabilityNotificationStatusItem`
 A key in the userInfo dictionary in a `AFNetworkingReachabilityDidChangeNotification` notification.
 The corresponding value is an `NSNumber` object representing the `AFNetworkReachabilityStatus` value for the current reachability status.
    */
    NSNumber *status = [[note userInfo] objectForKey:AFNetworkingReachabilityNotificationStatusItem];
    [self updateInterfaceWithReachability:status];
}

- (void)updateInterfaceWithReachability: (NSNumber *)status
{
    switch ([status integerValue]) {
        case AFNetworkReachabilityStatusNotReachable:
            NSLog(@"Sorry, internet not reachable.");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            NSLog(@"Lucky! You've got Wifi!");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@"Not bad! You've got WWAN!");
            break;
        default:
            NSLog(@"Oh, god! I don't know what happened to you..");
            break;
    }
}
