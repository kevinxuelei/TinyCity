//
//  AboutUsTableViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/25.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "AboutUsTableViewController.h"

@interface AboutUsTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation AboutUsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.dataArray = @[@"版本           :     1.02",@"开发人员    :  潘龙  董学雷   ", @"联系电话    :   101"];
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"usCell"];
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
    header.image = [UIImage imageNamed:@"backgourd"];
    self.tableView.tableHeaderView = header;
    self.tableView.tableFooterView = [[UIView alloc] init];
     self.tableView.scrollEnabled = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"usCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}
@end
