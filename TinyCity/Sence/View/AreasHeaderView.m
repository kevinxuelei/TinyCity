//
//  AreasHeaderView.m
//  TinyCity
//
//  Created by lanou3g on 15/11/14.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "AreasHeaderView.h"

@interface AreasHeaderView  ()

@property (nonatomic, strong) UIButton *nameView;

@end

@implementation AreasHeaderView
+(instancetype)AreasHeaderViewWithTableView:(UITableView *)tableView{
    
    static NSString *IDHeader = @"headerView";
    AreasHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:IDHeader];
    if (!header) {
        //header footer 初始化和cell一样要有重用标示符
        header = [[AreasHeaderView alloc] initWithReuseIdentifier:IDHeader];
    }
    return header;
    
}
/**
 *  初始化view
 *
 */
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
       
        // 1.添加按钮
        UIButton *nameView = [UIButton buttonWithType:UIButtonTypeCustom];
        // 设置按钮内部的左边箭头图片
        [nameView setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
        [nameView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 设置按钮的内容左对齐
        nameView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 设置按钮的内边距
        //        nameView.imageEdgeInsets
        nameView.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        nameView.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [nameView addTarget:self action:@selector(nameViewClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置按钮内部的imageView的内容模式为居中
        nameView.imageView.contentMode = UIViewContentModeCenter;
        // 超出边框的内容不需要裁剪
        nameView.imageView.clipsToBounds = NO;
        
        [self.contentView addSubview:nameView];
        self.nameView = nameView;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.nameView.frame = self.bounds;
    
}

-(void)setProvince:(Provinces *)province{
    
    _province = province;
    [self.nameView setTitle:province.name forState:UIControlStateNormal];
    
}

-(void)nameViewClick{
    
    self.province.opened = !self.province.isOpened;
    
    // 2.刷新表格
    if ( self.delegate && [self.delegate respondsToSelector:@selector(reloadData:)]) {
        [self.delegate reloadData:self];
    }
    
}

/**
 *  当一个控件被添加到父控件中就会调用
 */
- (void)didMoveToSuperview
{
    if (self.province.opened) {
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } else {
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
