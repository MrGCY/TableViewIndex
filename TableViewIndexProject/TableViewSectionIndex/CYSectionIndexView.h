//
//  CYSectionIndexView.h
//  TableViewIndexProject
//
//  Created by Mr.GCY on 2018/8/21.
//  Copyright © 2018年 Mr.GCY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYSectionIndexViewCell.h"
@class CYSectionIndexView;
//数据源
@protocol CYSectionIndexViewDataSource <NSObject>
@required
//返回索引数量
- (NSInteger)numberOfItemViewForSectionIndexView:(CYSectionIndexView *)sectionIndexView;
//返回索引展示内容
- (NSString *)sectionIndexView:(CYSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section;
@optional
//如果选择微信模式可以不用实现这个
- (CYSectionIndexViewCell *)sectionIndexView:(CYSectionIndexView *)sectionIndexView
                          itemViewForSection:(NSInteger)section;
//设置弹出视图样式
- (UIView *)sectionIndexView:(CYSectionIndexView *)sectionIndexView
       calloutViewForSection:(NSInteger)section;
@end
//代理
@protocol CYSectionIndexViewDelegate <NSObject>
//点击了某个索引的回调
- (void)sectionIndexView:(CYSectionIndexView *)sectionIndexView
        didSelectSection:(NSInteger)section;
//结束选中
-(void)sectionIndexView:(CYSectionIndexView *)sectionIndexView
       didEndSelectSection:(NSInteger)section;
@end

typedef NS_ENUM(NSInteger,CYCalloutViewType) {
     CYCalloutViewTypeForNone,//初始状态
     CYCalloutViewTypeForWeChat, //微信模式
     CYCalloutViewTypeForUserDefined//自定义模式
};

@interface CYSectionIndexView : UIView
@property (nonatomic, weak) id<CYSectionIndexViewDataSource>dataSource;
@property (nonatomic, weak) id<CYSectionIndexViewDelegate>delegate;
@property (nonatomic, assign) CYCalloutViewType  calloutType;
//是否点击索引
@property (nonatomic, assign,readonly) BOOL  isTouch;
//选中提示图与CYSectionIndexView的对象边缘的距离
@property (nonatomic, assign) CGFloat calloutMargin;
//存储所有的视图的容器
@property (nonatomic, strong) NSMutableArray *itemViewList;
//是否显示顶部弹出的视图 默认是YES
@property (nonatomic, assign) BOOL  isShowCallout;
- (void)registerNib:(nullable UINib *)nib forSectionIndexCellReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(nullable Class)sectionIndexCellClass forSectionIndexCellReuseIdentifier:(NSString *)identifier;
- (nullable __kindof CYSectionIndexViewCell *)dequeueSectionIndexCellWithReuseIdentifier:(NSString *)identifier;
//更新当前状态 只有在微信和普通模式下可用
-(void)uploadSectionIndexStatusWithCurrentIndex:(NSInteger)currentIndex;
//加载
-(void)reloadItems;
@end
