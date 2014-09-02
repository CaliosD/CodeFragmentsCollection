//
//  LDGravityViewController.m
//  UIDynamicDemo
//
//  Created by Lilac on 8/29/14.
//  Copyright (c) 2014 TZ. All rights reserved.
//

#import "LDGravityViewController.h"

@interface LDGravityViewController ()<UICollisionBehaviorDelegate>
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIDynamicAnimator *animato;

@end

@implementation LDGravityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    aView.backgroundColor = [UIColor cyanColor];
    aView.transform = CGAffineTransformRotate(aView.transform, 45);
    [self.view addSubview:aView];
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(200, 50, 100, 100)];
    bView.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:bView];
    
    /** Gravity */
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc]initWithItems:@[aView]];
    gravityBehavior.angle = 1.57;
    gravityBehavior.magnitude = 0.5;
    [self.animator addBehavior:gravityBehavior];
    
    self.animato = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *gravityBehavio = [[UIGravityBehavior alloc]initWithItems:@[bView]];
    gravityBehavio.angle = 3.14;
    gravityBehavio.magnitude = 0.05;
    [self.animato addBehavior:gravityBehavio];

    /** Collision */
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[aView,bView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
