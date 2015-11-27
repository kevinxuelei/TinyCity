//
//  ListTypeView.h
//  TinyCity
//
//  Created by lanou3g on 15/11/23.
//  Copyright © 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListTypeViewDelegate <NSObject>

-(void)ListTypeViewWithMapViewType:(int)count;

@end

@interface ListTypeView : UIView
@property (nonatomic, assign) id delegate;
@end
