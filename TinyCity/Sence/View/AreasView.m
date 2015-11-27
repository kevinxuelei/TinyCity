//
//  AreasView.m
//  TinyCity
//
//  Created by lanou3g on 15/11/14.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "AreasView.h"
#import "Provinces.h"
#import "City.h"
#import "AreasHeaderView.h"

@interface AreasView ()<UITableViewDelegate,UITableViewDataSource,AreasHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *areaDataArray;

@end

@implementation AreasView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        self.tableView = tableView;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"areaCell"];
        
        self.tableView.tableHeaderView = [[UIView alloc] init];
        
        [self loadTableViewData];
       
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
    self.tableView.tableHeaderView.height = 0;
    
}
-(void)loadTableViewData{
    
    NSArray *dataArr = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]] allValues];
    
    NSMutableArray *provincesArr = [NSMutableArray array];
    for (NSDictionary *dict in dataArr) {
        
        Provinces *provinces = [Provinces provincesWithDict:dict];
        [provincesArr addObject:provinces];
    }
    
    self.areaDataArray = provincesArr;
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.areaDataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    Provinces *province = self.areaDataArray[section];
    
    return (province.isOpened ? [province.cityArr count] : 0);
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"areaCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.areaDataArray[indexPath.section] cityArr][indexPath.row] name];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Provinces *province = self.areaDataArray[indexPath.section];
    NSString *provinceName = province.name;
    City *city = province.cityArr[indexPath.row];
    NSString *cityName = city.name;
    
    self.block(provinceName,cityName);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    AreasHeaderView *header = [AreasHeaderView AreasHeaderViewWithTableView:tableView];
    header.delegate = self;
    header.province = self.areaDataArray[section];
    return header;
}
-(void)reloadData:(AreasHeaderView *)headerView{
    
    [self.tableView reloadData];
}


@end
