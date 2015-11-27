//
//  HomeModelSaveTableViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "HomeModelSaveTableViewController.h"
#import "HomeModel.h"
#import "HomeSaveModelTableViewCell.h"
#import "VedioPlayController.h"

@interface HomeModelSaveTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HomeModelSaveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收藏";
    
    self.tableView.rowHeight = 90;
   
    
    [self loadData];
}
-(void)loadData{
    
    NSMutableArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KHomeSavePath];
    self.dataArray = dataArray;
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeSaveModelTableViewCell *cell = [HomeSaveModelTableViewCell HomeSaveModelTableViewCellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeModel *model= self.dataArray[indexPath.row];
    VedioPlayController *detail = [[VedioPlayController alloc] init];
    detail.nameUrl = model.videouri;
    [self.navigationController pushViewController:detail animated:YES];
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [NSKeyedArchiver archiveRootObject:self.dataArray toFile:KHomeSavePath];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
}



@end
