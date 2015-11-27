//
//  CellFrame.m
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "CellFrame.h"
#import "UIView+Extension.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define PAN 10

@implementation CellFrame

- (void)setModel:(HomeModel *)model
{
    _model = model;
    CGFloat width = (ScreenWidth - 3*PAN)/2;
    self.profile_imageFrame = CGRectMake(PAN, PAN,30 , 30);
    self.name_labelFrame = CGRectMake(CGRectGetMaxX(_profile_imageFrame)+5, PAN, width - 10, 15);
    self.created_at_labelFrame = CGRectMake(CGRectGetMinX(_name_labelFrame), CGRectGetMaxY(_name_labelFrame), CGRectGetWidth(_name_labelFrame), 15);
    CGFloat textHeight = [self stringWithByString:model.text fontSize:15 contentSize:CGSizeMake(width - 15-2, MAXFLOAT)];
    self.titleLabelFrame = CGRectMake(PAN, CGRectGetMaxY(_created_at_labelFrame)+5, width -15-2, textHeight);
    CGFloat imageWidth = model.width.floatValue;
    CGFloat imageHeight = model.height.floatValue;
    CGFloat height = width/imageWidth * imageHeight;
    self.bigImageViewFrame = CGRectMake(PAN, CGRectGetMaxY(_titleLabelFrame)+ 5, width - 15-2, height);
    CGFloat btnWidth = (width - 4*PAN)/3;
    self.saveButtonFrame = CGRectMake(PAN , CGRectGetMaxY(_bigImageViewFrame)+ 10, btnWidth, 25);
    self.transmitButtonFrame = CGRectMake(CGRectGetMaxX(_saveButtonFrame)+ 10, CGRectGetMinY(_saveButtonFrame), CGRectGetWidth(_saveButtonFrame), 25);
    self.reportButtonFrame = CGRectMake(CGRectGetMaxX(_transmitButtonFrame)+PAN , CGRectGetMaxY(_bigImageViewFrame)+PAN, CGRectGetWidth(_saveButtonFrame), 25);
    
    self.cellWidth = width;
    self.cellHeight = CGRectGetMaxY(_saveButtonFrame)+ 5;
    
}

- (CGFloat) stringWithByString:(NSString *)str fontSize:(CGFloat)fontSize contentSize:(CGSize)size
{
    CGRect stringH = [str boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return stringH.size.height;
}

@end
