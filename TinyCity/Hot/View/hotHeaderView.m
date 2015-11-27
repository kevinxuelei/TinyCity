//
//  hotHeaderView.m
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "hotHeaderView.h"
#import <UIImageView+WebCache.h>

@interface hotHeaderView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation hotHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator  = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIPageControl * pageControl = [[UIPageControl alloc] init];
        pageControl.currentPage = 0;
        pageControl.tintColor = [UIColor redColor];
        [self addSubview:pageControl ];
        self.pageControl = pageControl;
        [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        }
    return self;
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, 0, self.width, 200);
    self.pageControl.frame = CGRectMake(self.width / 3, 180, self.frame.size.width / 3, 20);
    _pageControl.pageIndicatorTintColor = PLRandomColor;
    _pageControl.currentPageIndicatorTintColor = PLRandomColor;
}

-(void)setHotDataArr:(NSArray *)hotDataArr{
    
    _hotDataArr = hotDataArr;
    self.pageControl.numberOfPages = self.hotDataArr.count;
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i=0; i < self.hotDataArr.count ; i++) {
        
        HotHeaderModel *model = self.hotDataArr[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled  = YES;
        imageView.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width , 200);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 200 - 40, self.frame.size.width -20 , 20)];
        label.text = model.title;
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        [label sizeToFit];
        label.font = [UIFont systemFontOfSize:16];
       // [imageView addSubview:label];
        [images addObject:imageView];
       [imageView sd_setImageWithURL:[NSURL URLWithString:model.titlepic]];
        
        UITapGestureRecognizer * tapGR =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tapGR];
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * images.count, 180);
    [self loadHeaderTimer];
}

-(void)tapAction:(UITapGestureRecognizer *)sender{
    
    HotHeaderModel *model = self.hotDataArr[self.pageControl.currentPage];
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(moveToDetailVC:)]) {
            [self.delegate moveToDetailVC:model];
        }
    
}

-(void)loadHeaderTimer{
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changePage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)changePage{
    int page = 0;
    if (self.pageControl.currentPage == self.hotDataArr.count - 1) {
        page = 0;
    }else{
        page = (int)self.pageControl.currentPage + 1;         }
    
    CGFloat kframeW = self.frame.size.width;
    CGPoint offset = CGPointMake(kframeW * page , 0);
    [UIView animateWithDuration:5.0f animations:^{
        [self.scrollView setContentOffset:offset animated:YES];
    }];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollW = scrollView.frame.size.width;
    int page = scrollView.contentOffset.x / scrollW;
    self.pageControl.currentPage  = page;
    
    CGFloat sectionHeaderHeight = 180;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(void)changePage:(UIPageControl *)sender{
    
    CGPoint offSet = CGPointMake(sender.currentPage * self.frame.size.width, 0);
    [self.scrollView setContentOffset:offSet animated:YES];
}


@end
