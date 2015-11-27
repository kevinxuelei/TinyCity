//
//  DetailViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/23.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "DetailViewController.h"
#import "HotTableViewCell.h"
#import "CommentTableViewCell.h"
#import "UIView+MLInputDodger.h"

@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *comentField;
@property (nonatomic, strong) UIButton *comentButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation DetailViewController

#pragma mark -- 单例
+ (instancetype)shareIntance
{
    static dispatch_once_t onceToken;
    static DetailViewController *detail = nil;
    dispatch_once(&onceToken, ^{
        detail = [[DetailViewController alloc] init];
    });
    return detail;
}

#pragma mark -- 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HotTableViewCell class] forCellReuseIdentifier:@"hot"];
        [_tableView registerNib:[UINib nibWithNibName:@"Comment" bundle:nil] forCellReuseIdentifier:@"comment"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.dataArray = [NSMutableArray array];
//    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadCommentData];
    [_tableView reloadData];
}

- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[HotTableViewCell class] forCellReuseIdentifier:@"hot"];
    [_tableView registerNib:[UINib nibWithNibName:@"Comment" bundle:nil] forCellReuseIdentifier:@"comment"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return  [self loadCommentView];
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    lable.font = [UIFont systemFontOfSize:14];
    lable.numberOfLines = 0;
    [lable sizeToFit];
    if (section == 1) {
        NSMutableString *str = [self loadDingPeople];
        lable.text =[str lowercaseString];
        return lable;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
         NSMutableString *str = [self loadDingPeople];
        CGFloat heitght = [self stringWithByString:str fontSize:14 contentSize:CGSizeMake(self.view.width, MAXFLOAT)];
        return heitght;
    }
    return 0;
}

#pragma mark -- 加载数据
- (void)loadCommentData
{
    AVQuery *query = [CommentModel query];
    AVObject *object = [query getObjectWithId:_cellF.model.model.objectId];
    NSMutableArray *array = [object objectForKey:@"commentContent"];
    self.dataArray = [array copy];
}


#pragma mark --loadCommentView
- (UIView *)loadCommentView
{
    UIView *comV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 74)];
//    comV.backgroundColor = PLRandomColor;
    self.tableView.tableFooterView = comV;
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(0, 0 , self.view.width - 50, 30)];
    field.placeholder = @"请输入评论";
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.delegate = self;
//    field.backgroundColor = PLRandomColor;
    [comV addSubview:field];
    self.comentField = field;
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(CGRectGetMaxX(field.frame), 0, 50, 30);
    [button setTitle:@"评论" forState:(UIControlStateNormal)];
//    button.backgroundColor = PLRandomColor;
    button.layer.cornerRadius = button.height/2;
    [button setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(toComment:) forControlEvents:(UIControlEventTouchUpInside)];
    [comV addSubview:button];
    self.comentButton = button;
    return comV;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark -- 评论
- (void)toComment:(UIButton *)sender
{
#pragma mark 评论
    if (_comentField.text.length == 0) {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"请输入评论内容！！！" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [alert show];
        return;
    }
    NSString *userN = [AVUser currentUser].username;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *timeText = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSMutableArray *arrays = [NSMutableArray arrayWithObjects:userN,_comentField.text,timeText, nil];
    AVQuery *query = [CommentModel query];
    AVObject *object = [query getObjectWithId:_cellF.model.model.objectId];
    NSMutableArray *array = [NSMutableArray array];
    array = [object objectForKey:@"commentContent"];
    [array addObject:arrays];
    _dataArray = [array copy];
    [object setObject:array forKey:@"commentContent"];
    [object setObject:[AVUser currentUser].username forKey:@"reviewers"];
    [object saveInBackground];
    
#pragma mark 获取评论点赞数量
    AVQuery *userInfoQ = [UserInfoModel query];
    AVObject *objectA =  [userInfoQ getObjectWithId:_cellF.model.objectId];
    NSString *commentCount = [NSString stringWithFormat:@"%ld",(unsigned long)_dataArray.count];
    [objectA setObject:commentCount forKey:@"relay_num"];
    [objectA saveInBackground];
    [_tableView reloadData];
//    NSIndexPath *index = [NSIndexPath indexPathForRow:_dataArray.count - 2 inSection:1];
//    [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    _comentField.text = @"";
}


#pragma mark 赞的人
- (NSMutableString *)loadDingPeople
{
    NSMutableString *strings = [NSMutableString string];
    AVQuery *query = [CommentModel query];
    AVObject *object = [query getObjectWithId:_cellF.model.model.objectId];
    NSArray *dataA = [object objectForKey:@"thumbsUp"];
    for (NSString *str in dataA) {
        [strings appendFormat:@"%@、",str];
    }
    [strings appendFormat:@"共%lu人觉得很赞",(unsigned long)dataA.count];
    return strings;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hot" forIndexPath:indexPath];
        cell.cellFrame = self.cellF;
        return cell;
    }else{
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment" forIndexPath:indexPath];
        NSMutableArray *dict = self.dataArray[indexPath.row];
        cell.dataA = dict;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _cellF.cellHeight+ 10;
    }else{
        NSMutableArray *dict = self.dataArray[indexPath.row];
        if (dict.count != 0) {
            NSString *text = [dict objectAtIndex:1];
            CGFloat height = [self stringWithByString:text fontSize:13 contentSize:CGSizeMake(self.view.width - 131, MAXFLOAT)];
            if (height > 65) {
                return height;
            }else{
                return 65;
            }
        }else{
            return 65;
        }
    }
}

- (CGFloat) stringWithByString:(NSString *)str fontSize:(CGFloat)fontSize contentSize:(CGSize)size
{
    CGRect stringH = [str boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return stringH.size.height;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.view endEditing:YES];
    
}

#pragma mark -- view向上推
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    
    [self.view registerAsDodgeViewForMLInputDodger];
}

@end
