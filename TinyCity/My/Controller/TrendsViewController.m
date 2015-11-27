//
//  TrendsViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "TrendsViewController.h"
#import "UserInfoModel.h"

@interface TrendsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellDataArr;

@end

@implementation TrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的动态";
    [self loadData];
    [self loadTableView];
}

-(void)loadTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)loadData
{
    self.cellDataArr = [NSMutableArray array];
    AVQuery *query = [UserInfoModel query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _cellDataArr = [objects copy];
        [self.tableView reloadData];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cellDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell" forIndexPath:indexPath];
    //
    //    cell.cellFrame = self.cellDataArr[indexPath.row];
    //
    //    return cell;
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:identifier];
    }
    cell.imageView.image = [UIImage imageNamed:@"default_head"];
    cell.textLabel.text = [self.cellDataArr[indexPath.row] userName];
    cell.detailTextLabel.text = [self.cellDataArr[indexPath.row] textInfo];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


@end
