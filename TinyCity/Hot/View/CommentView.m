//
//  CommentView.m
//  TinyCity
//
//  Created by lanou3g on 15/11/24.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "CommentView.h"

@interface CommentView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITextField *commentField;
@property (nonatomic, strong) UIButton *commentButton;
@end

@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.commentTableView = [[UITableView alloc] init];
//        self.commentTableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 30);
        _commentTableView.dataSource = self;
        _commentTableView.delegate = self;
        [self addSubview:_commentTableView];
        
        self.commentField = [[UITextField alloc] init];
        _commentField.placeholder = @"请输入文字";
//        self.commentField.frame = CGRectMake(0, _commentTableView.height, frame.size.width - 50, 30);
        _commentField.font = [UIFont systemFontOfSize:14];
        [self addSubview:_commentField];
        
        self.commentButton = [[UIButton alloc] init];
//        self.commentButton.frame = CGRectMake(frame.size.width - 50, _commentTableView.height, 50, 30);
        [self addSubview:_commentButton];
        [_commentButton addTarget:self action:@selector(loadData) forControlEvents:(UIControlEventTouchUpInside)];
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.commentTableView.frame = self.bounds;
    self.commentTableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 30);
    self.commentField.frame = CGRectMake(0, _commentTableView.height, self.width - 50, 30);
    self.commentButton.frame = CGRectMake(self.width - 50, _commentTableView.height, 50, 30);
}
#pragma mark -- 加载数据
- (void)loadData
{
    AVQuery * query = [AVQuery queryWithClassName:@"Album"];
    
    AVObject * object = [query getObjectWithId:[AVUser currentUser].objectId];
    
    //NSLog(@"%@",object.objectId);
    
    self.dataArray = object[@"comments"];
//
    NSDictionary * dic = @{@"comment":@"hahah",@"commentUser":[AVUser currentUser]};
//
    [self.dataArray addObject:dic];
//
    object[@"comments"]=self.dataArray;
    [object save];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"123";
    return cell;
}


@end
