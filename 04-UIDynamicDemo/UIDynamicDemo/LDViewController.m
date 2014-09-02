//
//  LDViewController.m
//  UIDynamicDemo
//
//  Created by Lilac on 8/29/14.
//  Copyright (c) 2014 TZ. All rights reserved.
//

#import "LDViewController.h"
#import "VVSpringCollectionViewFlowLayout.h"
#import "LDGravityViewController.h"

@interface LDViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

static NSString *cellIdentifier = @"collectionCellIdentifier";

@implementation LDViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Gravity & Collision";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    VVSpringCollectionViewFlowLayout *layout = [[VVSpringCollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(320, 40);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    [self.view addSubview:collectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LDGravityViewController *gravityViewController = [[LDGravityViewController alloc]init];
    [self.navigationController pushViewController:gravityViewController animated:YES];
}

@end
