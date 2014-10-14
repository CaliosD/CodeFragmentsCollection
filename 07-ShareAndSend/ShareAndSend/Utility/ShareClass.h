//
//  ShareClass.h
//  LDBlueMoon
//
//  Created by IceBoy on 14-3-20.
//  Copyright (c) 2014年 tranzvision. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LDAppDelegate.h"

#import "WXApi.h"
#import <RennSDK/RennSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <SMS_SDK/SMS_SDK.h>


@interface ShareClass : NSObject
+ (void)shareWithTitle :(NSString *)title
            andContent :(NSString *)content
                andUrl :(NSString *)url;
+(void)configShareType;

@end
