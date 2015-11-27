#import <UIKit/UIKit.h>

@protocol WaterFlowDelegate <NSObject>

// 获取item高度
- (CGFloat)heightForItemIndexPath:(NSIndexPath *)indexPath;

@end


@interface WaterFlowLayout : UICollectionViewLayout
// item大小
@property (nonatomic,assign)CGSize itemSize;
// 内边距
@property (nonatomic,assign)UIEdgeInsets sectionInsets;
// item 间距
@property (nonatomic,assign)CGFloat insertItemSpacing;
// 列
@property (nonatomic,assign)NSUInteger numberOfColumns;

//代理
@property (nonatomic,weak)id<WaterFlowDelegate>delegate;



@end
