//
//  AddFriendsViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "CDImageLabelTableCell.h"
#import <UIImage+Icon.h>
#import "CDUserInfoVC.h"

@interface AddFriendsViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) AVIMClient *client;
@property (nonatomic, strong) NSMutableArray *userArray;
@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查找好友";
    _tableV = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    _tableV.y = 35;
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 0, self.view.width - 10, 35)];
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    [self searchUser:@""];
}
static NSString *cellIndentifier = @"cellIndentifier";
- (void)searchUser:(NSString *)name
{
    self.userArray = [NSMutableArray array];
    AVQuery *query = [AVUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _userArray = [objects copy];
        [self.tableV reloadData];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDImageLabelTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[CDImageLabelTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    AVUser *user = self.userArray[indexPath.row];
    cell.myLabel.text = user.username;
    AVFile *avatar = [user objectForKey:@"avatar"];
    if (avatar) {
        [avatar getDataInBackgroundWithBlock: ^(NSData *data, NSError *error) {
            if (error == nil) {
                cell.myImageView.image = [UIImage imageWithData:data];
            }
            else {
                cell.myImageView.image = [self defaultAvatarOfUser:user];
            }
        }];
    }
    else {
        cell.myImageView.image = [self defaultAvatarOfUser:user];
    }
    return cell;
}
- (UIImage *)defaultAvatarOfUser:(AVUser *)user {
    return [UIImage imageWithHashString:user.objectId displayString:[[user.username substringWithRange:NSMakeRange(0, 1)] capitalizedString]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CDUserInfoVC *controller = [[CDUserInfoVC alloc]initWithUser:_userArray[indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

@end
