//
//  ShareClass.m
//  LDBlueMoon
//
//  Created by IceBoy on 14-3-20.
//  Copyright (c) 2014年 tranzvision. All rights reserved.
//

#import "ShareClass.h"

@implementation ShareClass


+(void)shareWithTitle:(NSString *)title
            andContent:(NSString *)content
                andUrl:(NSString *)url

{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon@2x" ofType:@"png"];
    
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:title
                                                  url:url
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];
    
    ///////////////////////
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    
    //定制人人网信息
    [publishContent addRenRenUnitWithName:NSLocalizedString(@"TEXT_HELLO_RENREN", @"Hello 人人网")
                              description:INHERIT_VALUE
                                      url:INHERIT_VALUE
                                  message:INHERIT_VALUE
                                    image:INHERIT_VALUE
                                  caption:nil];
    
    
    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:NSLocalizedString(@"TEXT_HELLO_QZONE", @"Hello QQ空间")
                                        url:@"http://www.baidu.com"
                                       site:nil
                                    fromUrl:nil
                                    comment:INHERIT_VALUE
                                    summary:INHERIT_VALUE
                                      image:INHERIT_VALUE
                                       type:INHERIT_VALUE
                                    playUrl:nil
                                       nswb:nil];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:@"美课分享测试iOS"
                                             url:@"http://www.baidu.com"
                                      thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
                                           image:INHERIT_VALUE
                                    musicFileUrl:@"http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3"
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
                                          content:@"wwwww"
                                            title:NSLocalizedString(@"TEXT_HELLO_WECHAT_TIMELINE", @"Hello 微信朋友圈!")
                                              url:@"http://www.baidu.com"
                                       thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
                                            image:[ShareSDK imageWithPath:imagePath]
                                     musicFileUrl:@"http://zhangmenshiting.baidu.com/data2/music/118358164/14385500158400128.mp3?xcode=5a243a438fbc8dbe8a399ad922b73fd331ba6b5fb13a98ae"
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制微信收藏信息
    [publishContent addWeixinFavUnitWithType:INHERIT_VALUE
                                     content:INHERIT_VALUE
                                       title:NSLocalizedString(@"TEXT_HELLO_WECHAT_FAV", @"Hello 微信收藏!")
                                         url:@"http://www.baidu.com"
                                  thumbImage:[ShareSDK imageWithUrl:@""]
                                       image:INHERIT_VALUE
                                musicFileUrl:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil];
    
    //定制QQ分享信息
    [publishContent addQQUnitWithType:INHERIT_VALUE
                              content:@"想学什么课啊"
                                title:@"优质课程"
                                  url:@"http://www.tranzvision.com.cn"
                                image:[ShareSDK imageWithPath:imagePath]];
    
    //定制邮件信息
    [publishContent addMailUnitWithSubject:@"Hello Mail"
                                   content:INHERIT_VALUE
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:INHERIT_VALUE
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    
    //定制短信信息
    [publishContent addSMSUnitWithContent:@"Hello SMS"];

    
    //结束定制信息
    ////////////////////////
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //  [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiFav),
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                          SHARE_TYPE_NUMBER(ShareTypeSMS),
                          SHARE_TYPE_NUMBER(ShareTypeMail),
                          nil];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"TEXT_SHARE_TITLE", @"内容分享")
                                                              oneKeyShareList:shareList
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertView *share = [[UIAlertView alloc]initWithTitle:@"" message:[error errorDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [share show];
                                    //NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorLevel], [error errorDescription]);
                                }
                            }];
  
}

+(void)configShareType
{
    [SMS_SDK registerApp:@"3064554ba0cf" withSecret:@"d6dcf8a216b361dd6f6834a9e29c570f"];

    [ShareSDK registerApp:@"ea67c2169e0"];
    [ShareSDK connectSinaWeiboWithAppKey:@"4240722665"
                               appSecret:@"22690992e6d13aa1a26389244e98f9bd"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    [ShareSDK connectQZoneWithAppKey:@"100554010"
                           appSecret:@"55dd9ab3bb016e6bc2ee45deb323c9f6"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    [ShareSDK connectWeChatWithAppId:@"wxea9083c6dc5ee3a3"
                           wechatCls:[WXApi class]];
//    [ShareSDK connectQQWithAppId:@"1101346330" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"100554010"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    [ShareSDK connectRenRenWithAppId:@"267673"
                              appKey:@"530ede3a4efa40c39369855b9f3d10d4"
                           appSecret:@"c34e20c391244cecbba3980b8ab1749b"
                   renrenClientClass:[RennClient class]];
}


@end
