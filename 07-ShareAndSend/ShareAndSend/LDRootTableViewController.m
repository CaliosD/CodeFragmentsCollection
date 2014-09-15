//
//  LDRootTableViewController.m
//  ShareAndSend
//
//  Created by Lilac on 9/12/14.
//  Copyright (c) 2014 TZ. All rights reserved.
//

#import "LDRootTableViewController.h"
#import "LDRNLViewController.h"
#import "LDShareViewController.h"
#import "LDAuthViewController.h"

@interface LDRootTableViewController ()

@property(nonatomic, strong) NSArray *data;

@end


@implementation LDRootTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Share n Send";
        _data = @[NSLocalizedString(@"CELL_LOGIN_N_REGISTER",nil),NSLocalizedString(@"CELL_SHARES",nil),NSLocalizedString(@"CELL_AUTH_N_CANCEL",nil)];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = [_data objectAtIndex:indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LDRNLViewController *rViewController = [[LDRNLViewController alloc]init];
        // Lilac: The following line is added for pause issue when animated argument is set YES.
        rViewController.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:rViewController animated:YES];
    }else if (indexPath.section == 1){
        LDShareViewController *sViewController = [[LDShareViewController alloc]init];
        sViewController.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:sViewController animated:YES];
    }else if (indexPath.section == 2){
        LDAuthViewController *aViewController = [[LDAuthViewController alloc]init];
        aViewController.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:aViewController animated:YES];
    }
}

@end
