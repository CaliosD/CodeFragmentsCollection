//
//  ShareClass.h
//  LDBlueMoon
//
//  Created by IceBoy on 14-3-20.
//  Copyright (c) 2014年 tranzvision. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LDAppDelegate.h"
@interface ShareClass : NSObject
+ (void)shareWithTitle :(NSString *)title
            andContent :(NSString *)content
                andUrl :(NSString *)url;
+(void)configShareType;

@end
