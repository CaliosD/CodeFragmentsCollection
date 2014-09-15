//
//  LDAppDelegate.m
//  ShareAndSend
//
//  Created by Lilac on 9/11/14.
//  Copyright (c) 2014 TZ. All rights reserved.
//

#import "LDAppDelegate.h"
#import "LDRootTableViewController.h"
#import "ShareClass.h"

@implementation LDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ShareClass configShareType];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    //监听用户信息变更
    [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                               target:self
                               action:@selector(userInfoUpdateHandler:)];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LDRootTableViewController *viewController = [[LDRootTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self.window setRootViewController:nav];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSMutableArray *authList = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
    if (authList == nil)
    {
        authList = [NSMutableArray array];
    }
    
    NSString *platName = nil;
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    switch (plat)
    {
        case ShareTypeSinaWeibo:
            platName = NSLocalizedString(@"TEXT_SINA_WEIBO", @"新浪微博");
            break;
        case ShareType163Weibo:
            platName = NSLocalizedString(@"TEXT_NETEASE_WEIBO", @"网易微博");
            break;
        case ShareTypeDouBan:
            platName = NSLocalizedString(@"TEXT_DOUBAN", @"豆瓣");
            break;
        case ShareTypeFacebook:
            platName = @"Facebook";
            break;
        case ShareTypeKaixin:
            platName = NSLocalizedString(@"TEXT_KAIXIN", @"开心网");
            break;
        case ShareTypeQQSpace:
            platName = NSLocalizedString(@"TEXT_QZONE", @"QQ空间");
            break;
        case ShareTypeRenren:
            platName = NSLocalizedString(@"TEXT_RENREN", @"人人网");
            break;
        case ShareTypeSohuWeibo:
            platName = NSLocalizedString(@"TEXT_SOHO_WEIBO", @"搜狐微博");
            break;
        case ShareTypeTencentWeibo:
            platName = NSLocalizedString(@"TEXT_TENCENT_WEIBO", @"腾讯微博");
            break;
        case ShareTypeTwitter:
            platName = @"Twitter";
            break;
        case ShareTypeInstapaper:
            platName = @"Instapaper";
            break;
        case ShareTypeYouDaoNote:
            platName = NSLocalizedString(@"TEXT_YOUDAO_NOTE", @"有道云笔记");
            break;
        case ShareTypeGooglePlus:
            platName = @"Google+";
            break;
        case ShareTypeLinkedIn:
            platName = @"LinkedIn";
            break;
        default:
            platName = NSLocalizedString(@"TEXT_UNKNOWN", @"未知");
    }
    
    id<ISSPlatformUser> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    BOOL hasExists = NO;
    for (int i = 0; i < [authList count]; i++)
    {
        NSMutableDictionary *item = [authList objectAtIndex:i];
        ShareType type = (ShareType)[[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            hasExists = YES;
            break;
        }
    }
    
    if (!hasExists)
    {
        NSDictionary *newItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 platName,
                                 @"title",
                                 [NSNumber numberWithInteger:plat],
                                 @"type",
                                 [userInfo nickname],
                                 @"username",
                                 nil];
        [authList addObject:newItem];
    }
    
    [authList writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
