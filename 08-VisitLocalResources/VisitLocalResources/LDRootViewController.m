//
//  LDRootViewController.m
//  VisitLocalResources
//
//  Created by Lilac on 9/15/14.
//  Copyright (c) 2014 TZ. All rights reserved.
//

#import "LDRootViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <SMS_SDK/SMS_SDK.h>


enum TableRowSelected
{
	kUIProfileImageRow = 0,
	kUINickNameRow,
	kUISexRow,
	kUITelephoneNoRow
};

enum TableRowSelected2
{
    kUIMainContactRow = 10,
    kUIAddressRow
};

#define IMGPICKER_ACTION_SHEET  111
#define SEXPICKER_ACTION_SHEET  222

@interface LDRootViewController ()<ABPeoplePickerNavigationControllerDelegate>

@property(nonatomic,strong) NSMutableArray *data;  // menu data from plist file
@property(nonatomic,strong) NSArray *sexArray;

@property(nonatomic,strong) UIImage *profileImg;
@property(nonatomic,strong) NSString *nickName;
@property(nonatomic,strong) NSString *sex;
@property(nonatomic,strong) NSString *telNO;
@property(nonatomic,strong) NSString *mainContact;


//@property(nonatomic,strong) ShowNewFriendsCountBlock friendsBlock;

@end

static UIAlertView* _alert1=nil;

@implementation LDRootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"个人信息";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        NSLog(@"—----------》Check local data:\n %@, \n %@, \n %@, \n %@, \n %@",
              [UIImage imageWithData:[defaults objectForKey:@"profileImg"]],
              [defaults valueForKey:@"nickName"],
              [defaults valueForKey:@"sex"],
              [defaults valueForKey:@"telNo"],
              [defaults valueForKey:@"mainContact"]);
    }
    return self;
}

- (void)prepareData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    _data = [NSMutableArray arrayWithContentsOfFile:plistPath];
    [self.tableView reloadData];
    
    _sexArray = @[@"男",@"女"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveItemPressed)];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    [self prepareData];
//    
//    _friendsBlock=^(enum SMS_ResponseState state,int latelyFriendsCount)
//    {
//        if (1==state) {
//            NSLog(@"block 新好友数目重新设置 %d",latelyFriendsCount);
//        }
//    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveItemPressed
{
    NSLog(@"data: %@",_data);
    // Create instances of NSData
    NSData *imageData = UIImageJPEGRepresentation(_profileImg, 100);
    
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:imageData forKey:@"profileImg"];
    [defaults setObject:_nickName forKey:@"nickName"];
    [defaults setObject:_sex forKey:@"sex"];
    [defaults setObject:_telNO forKey:@"telNo"];
    [defaults setObject:_mainContact forKey:@"mainContact"];
    [defaults synchronize];

    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"个人信息保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    _alert1=alert;
    [alert show];
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
    return [[_data objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[[_data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"title"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (_profileImg == nil) {
            _profileImg = [UIImage imageNamed:@"profileDefault.png"];
        }
        UIImageView *profileImgView = [[UIImageView alloc]initWithFrame:CGRectMake(320 - 80, 10, 60, 60)];
        profileImgView.image = _profileImg;
        profileImgView.layer.masksToBounds = YES;
        profileImgView.layer.cornerRadius = 5.f;
        [cell.contentView addSubview:profileImgView];

    }else{
        cell.detailTextLabel.text = [[[_data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"description"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0 && indexPath.row == 0)? 80 : 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case kUIProfileImageRow:
                [self showUIImagePicker];
                break;
            case kUINickNameRow:
                [self showNicknameAlert];
                break;
            case kUISexRow:
                [self showSexPicker];
                break;
            case kUITelephoneNoRow:
                [self makeACall];
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row + 10) {
            case kUIMainContactRow:
                [self showPeoplePickerController];
                break;
            case kUIAddressRow:
                [self showLocationWithMap];
            default:
                break;
        }
    }

}

#pragma mark Tableview did select Actions

-(void)showUIImagePicker
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    actionSheet.tag = IMGPICKER_ACTION_SHEET;
    [actionSheet showInView:self.view];
}

-(void)showNicknameAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"昵称" message:@"请输入昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    if (_nickName) {
        [alert textFieldAtIndex:0].text = _nickName;
    }
    [alert show];
}

-(void)showSexPicker
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    actionSheet.tag = SEXPICKER_ACTION_SHEET;
    [actionSheet showInView:self.view];
}

-(void)makeACall
{
    _telNO = [[[_data objectAtIndex:0] objectAtIndex:3]valueForKey:@"description"];
    NSString *telStr = [NSString stringWithFormat:@"telprompt://%@",_telNO];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
}

-(void)showPeoplePickerController
{
    NSLog(@"showPeoplePickerController");
    
    //判断用户通讯录是否授权
    if (_alert1) {
        [_alert1 show];
    }
    
    if(ABAddressBookGetAuthorizationStatus()!=kABAuthorizationStatusAuthorized&&_alert1==nil)
    {
        NSString* str=[NSString stringWithFormat:@"您未授权访问联系人，请在【设置>隐私>通讯录】中授权访问，就可以看到通讯录好友了哦"];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        _alert1=alert;
        [alert show];
    }else{
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        // Display only a person's phone, email, and birthdate
        NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                                   [NSNumber numberWithInt:kABPersonEmailProperty],
                                   [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
        
        picker.displayedProperties = displayedItems;
        // Show the picker
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)showLocationWithMap
{
    NSLog(@"showLocationWithMap");
}

/*
#pragma mark UIPicker delegate & datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_sexArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}
*/
#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *nickField = [alertView textFieldAtIndex:0];
        _nickName = nickField.text;
        
        [[[_data objectAtIndex:0] objectAtIndex:1] setValue:_nickName forKey:@"description"];
        [self.tableView reloadData];
    }
}

#pragma mark UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    _profileImg = image;
    [self.tableView reloadData];

    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark ActionSheet Action

-(void)imagePickerClickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if (buttonIndex == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"当前设备上相机不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
            
        }
    }else if (buttonIndex == 1){
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

-(void)sexPickerClickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 || buttonIndex == 1) {
        _sex = [_sexArray objectAtIndex:buttonIndex];
        [[[_data objectAtIndex:0] objectAtIndex:2] setValue:_sex forKey:@"description"];
        [self.tableView reloadData];
    }
}

#pragma mark Actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case IMGPICKER_ACTION_SHEET:
            [self imagePickerClickedButtonAtIndex:buttonIndex];
            break;
        case SEXPICKER_ACTION_SHEET:
            [self sexPickerClickedButtonAtIndex:buttonIndex];
            break;
        default:
            break;
    }

}

#pragma mark ABPeoplePickerNavigationController Delegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    if (property == kABPersonPhoneProperty) {
    	ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++)
        {
            NSString *phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multiPhones, i);
            NSLog(@"PHONE : %@", phoneNumber);
            _mainContact = phoneNumber;
            [[[_data objectAtIndex:1] objectAtIndex:0] setValue:_mainContact forKey:@"description"];
            [self.tableView reloadData];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    return NO;
}


@end
