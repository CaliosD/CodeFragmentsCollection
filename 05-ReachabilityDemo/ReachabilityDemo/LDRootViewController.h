//
//  LDRootViewController.h
//  ThuSemMBACheckInTest
//
//  Created by Lilac on 1/26/14.
//  Copyright (c) 2014 Lilac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>

@interface LDRootViewController : UIViewController
{
    UILabel *ADIDLabel;
    UILabel *netStatusLabel;
    UILabel *myLocationLabel;
    UILabel *locationStyleLabel;
    UILabel *accurateLabel;
    UILabel *timeLabel;
    UILabel *locationDesLabel;
}

@property (nonatomic, strong) NSTimer *timer;


@end
