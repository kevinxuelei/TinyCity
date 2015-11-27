//
//  HotCellFrame.m
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "HotCellFrame.h"
#define KMargin 10
#define kFrameW [UIScreen mainScreen].bounds.size.width

@implementation HotCellFrame

- (void)setModel:(UserInfoModel *)model
{
    _model = model;
    
    
    self.profile_imageFrame = CGRectMake(KMargin, KMargin, 40, 40);
    self.nameFrame = CGRectMake(CGRectGetMaxX(self.profile_imageFrame) + KMargin, KMargin, kFrameW - 20, 20);
    self.created_atFrame = CGRectMake(CGRectGetMaxX(self.profile_imageFrame) + KMargin, CGRectGetMaxY(self.nameFrame), kFrameW - 100, 20);
    
    CGFloat contentH = [self stringWithByString:model.textInfo fontSize:15 contentSize:CGSizeMake(kFrameW - 2*KMargin, MAXFLOAT)];
    
    self.contentFrame = CGRectMake(KMargin, CGRectGetMaxY(self.profile_imageFrame) + KMargin, kFrameW - 2*KMargin, contentH);
    CGFloat y = 0;
    if (model.file.url.length != 0) {
        self.pictureFrame = CGRectMake(KMargin, CGRectGetMaxY(_contentFrame)+10, kFrameW - 2*KMargin, 150);
    }
    if (model.file.url.length != 0) {
        y = CGRectGetMaxY(_pictureFrame)+10;
    }else{
        y = CGRectGetMaxY(_contentFrame)+10;
    }
    CGFloat width = (kFrameW - 4*KMargin)/3;
//    self.skimFrame = CGRectMake(KMargin, y,width , 30);
    self.locationFrame = CGRectMake(KMargin, y, 2*width, 30);
    self.applauseFrame = CGRectMake(CGRectGetMaxX(_locationFrame)+KMargin,y, width/2, 30);
    self.replayFrame = CGRectMake(CGRectGetMaxX(self.applauseFrame)+KMargin , y, width/2, 30);
    self.cellHeight = CGRectGetMidY(self.applauseFrame) + KMargin;
}

- (CGFloat) stringWithByString:(NSString *)str fontSize:(CGFloat)fontSize contentSize:(CGSize)size
{
    CGRect stringH = [str boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return stringH.size.height;
}


@end
