//
//  ListTypeView.m
//  TinyCity
//
//  Created by lanou3g on 15/11/23.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "ListTypeView.h"

@interface ListTypeView ()

@property (nonatomic, strong) UIButton *firstButton;

@property (nonatomic, strong) UIButton *secondButton;

@property (nonatomic, strong) UIButton *thirdButton;

@end

@implementation ListTypeView



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.firstButton = [self createButtonWithImageUrl:@"maplayer_manager_2d_hl" andTarget:@selector(firstAction:)];
        self.secondButton = [self createButtonWithImageUrl:@"maplayer_manager_3d_hl" andTarget:@selector(secondAction:)];
        self.thirdButton = [self createButtonWithImageUrl:@"maplayer_manager_sate_hl" andTarget:@selector(ThirdAction:)];
        
    }
    
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat buttonW = (self.frame.size.width - 40) / 3;
    CGFloat buttonH = 110;
    
    self.firstButton.frame = CGRectMake(10, 10, buttonW, buttonH);
    self.secondButton.frame = CGRectMake(CGRectGetMaxX(self.firstButton.frame) + 10, 10, buttonW, buttonH);
    self.thirdButton.frame = CGRectMake(CGRectGetMaxX(self.secondButton.frame) + 10, 10, buttonW, buttonH);
    
}

-(void)firstAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ListTypeViewWithMapViewType:)]) {
        
        [self.delegate ListTypeViewWithMapViewType:1];
    }
    
}
-(void)secondAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ListTypeViewWithMapViewType:)]) {
        
        [self.delegate ListTypeViewWithMapViewType:2];
    }
    
}

-(void)ThirdAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ListTypeViewWithMapViewType:)]) {
        
        [self.delegate ListTypeViewWithMapViewType:3];
    }
    
    
}
-(UIButton *)createButtonWithImageUrl:(NSString *)imageUrl andTarget:(SEL)action{
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button setImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    return button;
}


@end
