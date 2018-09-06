//
//  CYSectionIndexView.m
//  TableViewIndexProject
//
//  Created by Mr.GCY on 2018/8/21.
//  Copyright © 2018年 Mr.GCY. All rights reserved.
//

#import "CYSectionIndexView.h"
#import "CYCustomSectionIndexCell.h"
#define identifierCYCustomSectionIndexCell @"CYCustomSectionIndexCell"
#define identifierCYSectionIndexViewCell @"CYSectionIndexViewCell"

// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
@interface CYSectionIndexView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * sectionIndexTableView;
@property (nonatomic, assign) NSInteger  numberItems;
//选中的
@property (nonatomic, assign) NSInteger  selectIndex;
//顶上弹出的view
@property (nonatomic, retain) UIView *calloutView;

@property (nonatomic, strong) UILabel * tipLabel;
@property (nonatomic, assign) NSInteger  lastIndex;
@property (nonatomic, assign,readwrite) BOOL  isTouch;
@end

@implementation CYSectionIndexView
#pragma mark- 初始化
- (id)initWithFrame:(CGRect)frame{
     self = [super initWithFrame:frame];
     if (self) {
          [self setupData];
          [self setupSubViews];
     }
     return self;
}
-(void)didMoveToWindow{
     [super didMoveToWindow];
     [self reloadItems];
}
-(void)setupData{
     self.selectIndex = -1;
     self.lastIndex = -1;
}
-(void)setupSubViews{
     self.isTouch = NO;
     self.isShowCallout = YES;
     self.sectionIndexTableView = [[UITableView alloc] init];
     self.sectionIndexTableView.backgroundColor = [UIColor clearColor];
     self.sectionIndexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     self.sectionIndexTableView.delegate = self;
     self.sectionIndexTableView.dataSource = self;
     self.sectionIndexTableView.showsVerticalScrollIndicator = NO;
     self.sectionIndexTableView.bounces = NO;
     self.sectionIndexTableView.userInteractionEnabled = NO;
     [self addSubview: self.sectionIndexTableView];

     NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"TableViewSectionIndex"ofType:@"bundle"];
     NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
     [self registerNib:[UINib nibWithNibName:identifierCYCustomSectionIndexCell bundle:resourceBundle] forSectionIndexCellReuseIdentifier:identifierCYCustomSectionIndexCell];
     [self registerClass:[CYSectionIndexViewCell class] forSectionIndexCellReuseIdentifier:identifierCYSectionIndexViewCell];
}
#pragma mark- setter
-(void)setIsShowCallout:(BOOL)isShowCallout{
     if (self.calloutType == CYCalloutViewTypeForWeChat) {
          _isShowCallout = YES;
          return;
     }
     _isShowCallout = isShowCallout;
}
#pragma mark- lazy
-(NSMutableArray *)itemViewList{
     if (!_itemViewList) {
          _itemViewList = [NSMutableArray arrayWithCapacity:0];
     }
     return _itemViewList;
}
#pragma mark- common
- (void)registerNib:(nullable UINib *)nib forSectionIndexCellReuseIdentifier:(NSString *)identifier{
     if (!nib) {
          return;
     }
     [self.sectionIndexTableView registerNib:nib forCellReuseIdentifier:identifier];
}
- (void)registerClass:(nullable Class)sectionIndexCellClass forSectionIndexCellReuseIdentifier:(NSString *)identifier{
     [self.sectionIndexTableView registerClass:sectionIndexCellClass forCellReuseIdentifier:identifier];
}
- (nullable __kindof CYSectionIndexViewCell *)dequeueSectionIndexCellWithReuseIdentifier:(NSString *)identifier
{
     return [self.sectionIndexTableView dequeueReusableCellWithIdentifier:identifier];
}
#pragma mark- private
//获取每个索引的高度
-(CGFloat)sectionIndexItemHeightByItems:(NSInteger)itemNum{
     CGFloat h = self.bounds.size.height;
     //默认20
     CGFloat sectionIndexItemH = 20;
     if (sectionIndexItemH * itemNum > h) {
          sectionIndexItemH = h / itemNum;
     }
     return sectionIndexItemH;
}
//加载
-(void)reloadItems{
     [self setupData];
     [self.itemViewList removeAllObjects];
     NSInteger numberOfItems = 1;
     if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemViewForSectionIndexView:)]) {
          numberOfItems = [_dataSource numberOfItemViewForSectionIndexView:self];
     }
     CGFloat h = self.bounds.size.height;
     CGFloat w = self.bounds.size.width;
     CGFloat sectionIndexItemH = [self sectionIndexItemHeightByItems:numberOfItems];
     CGFloat sectionIndexH = sectionIndexItemH * numberOfItems;
     self.sectionIndexTableView.frame = CGRectMake(0, 0, w, sectionIndexH);
     self.sectionIndexTableView.center = CGPointMake(w * 0.5, h * 0.5);
     self.sectionIndexTableView.rowHeight = sectionIndexItemH;
     self.numberItems = numberOfItems;
     [self.sectionIndexTableView reloadData];
}
- (void)selectItemViewForSection:(NSInteger)section andCellRect:(CGRect)cellRect{
     [self uploadSectionIndexStatusWithCurrentIndex:self.selectIndex];
     if (self.isShowCallout) {
          CGFloat centerY = cellRect.origin.y + cellRect.size.height * 0.5 + self.frame.origin.y + self.sectionIndexTableView.frame.origin.y;
          CGFloat centerX = 0;
          CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
          CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
          if (self.dataSource && [self.dataSource respondsToSelector:@selector(sectionIndexView:calloutViewForSection:)] && self.calloutType == CYCalloutViewTypeForUserDefined) {
               //用户自定义弹框
               [self.calloutView removeFromSuperview];
               if (self.calloutView) {
                    self.calloutView = nil;
               }
               self.calloutView = [self.dataSource sectionIndexView:self calloutViewForSection:section];
               [self.superview addSubview:self.calloutView];
          }else if(self.calloutType == CYCalloutViewTypeForWeChat){
               //微信模式
               if (!self.calloutView) {
                    self.calloutView = [[UIView alloc] init];
                    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"TableViewSectionIndex"ofType:@"bundle"];
                    NSString *imgPath= [bundlePath stringByAppendingPathComponent:@"index_partner_view_bg"];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgPath]];
                    [imageView sizeToFit];
                    [self.calloutView addSubview:imageView];
                    self.calloutView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
                    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.calloutView.frame) - 30)/2, 50, 30)];
                    tipLabel.backgroundColor = [UIColor clearColor];
                    tipLabel.textColor = [UIColor whiteColor];
                    tipLabel.font = [UIFont boldSystemFontOfSize:32];
                    tipLabel.textAlignment = NSTextAlignmentCenter;
                    [self.calloutView addSubview:tipLabel];
                    [self.superview addSubview:self.calloutView];
                    self.calloutMargin = 10;
                    self.tipLabel = tipLabel;
               }
               if (self.dataSource && [self.dataSource respondsToSelector:@selector(sectionIndexView:titleForSection:)]) {
                    if (self.tipLabel) {
                         self.tipLabel.text = [self.dataSource sectionIndexView:self titleForSection:section];
                    }
               }
          }else{
               //其他初始模式
               if (!self.calloutView) {
                    self.calloutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
                    self.calloutView.backgroundColor = [UIColor greenColor];
                    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.calloutView.frame) - 30)/2, 50, 30)];
                    tipLabel.backgroundColor = [UIColor clearColor];
                    tipLabel.textColor = [UIColor redColor];
                    tipLabel.font = [UIFont boldSystemFontOfSize:32];
                    tipLabel.textAlignment = NSTextAlignmentCenter;
                    [self.calloutView addSubview:tipLabel];
                    [self.superview addSubview:self.calloutView];
                    self.calloutMargin = 10;
                    self.tipLabel = tipLabel;
               }
               if (self.dataSource && [self.dataSource respondsToSelector:@selector(sectionIndexView:titleForSection:)]) {
                    if (self.tipLabel) {
                         self.tipLabel.text = [self.dataSource sectionIndexView:self titleForSection:section];
                    }
               }
          }
          if ((centerY + self.calloutView.frame.size.height * 0.5) >= screenH) {
               centerY = screenH - self.calloutView.frame.size.height * 0.5;
          }else if((centerY - self.calloutView.frame.size.height * 0.5) <= 0){
               centerY = self.calloutView.frame.size.height * 0.5;
          }
          centerX = self.frame.origin.x - self.calloutMargin - self.calloutView.frame.size.width * 0.5;
          if (centerX <= 0) {
               centerX = self.calloutView.frame.size.width * 0.5;
          }else if(centerX >= screenW){
               centerX = screenW - self.calloutView.frame.size.height * 0.5;
          }
          self.calloutView.center = CGPointMake(centerX, centerY);
     }
}
-(void)hidenCalloutView{
     self.isTouch = NO;
     if (self.isShowCallout) {
          [UIView animateWithDuration:0.2 animations:^{
               self.calloutView.alpha = 0.0;
          } completion:^(BOOL finished) {
               self.selectIndex = -1;
               [self.calloutView removeFromSuperview];
               [self.tipLabel removeFromSuperview];
               if (self.calloutView) {
                    self.calloutView = nil;
                    self.tipLabel = nil;
               }
          }];
     }
}
//更新当前状态
-(void)uploadSectionIndexStatusWithCurrentIndex:(NSInteger)currentIndex{
     if (currentIndex == self.lastIndex || self.itemViewList.count == 0 || self.itemViewList.count < currentIndex) {
          return;
     }
     if (self.calloutType == CYCalloutViewTypeForWeChat) {
          
          CYCustomSectionIndexCell * currentCell = (CYCustomSectionIndexCell *)self.itemViewList[currentIndex];
          CYCustomSectionIndexCell * lastCell = [CYCustomSectionIndexCell new];
          if (self.lastIndex >= 0) {
               lastCell = (CYCustomSectionIndexCell *)self.itemViewList[self.lastIndex];
          }
          currentCell.sectionLabel.backgroundColor = [UIColor greenColor];
          currentCell.sectionLabel.textColor = [UIColor whiteColor];
          lastCell.sectionLabel.backgroundColor = [UIColor clearColor];
          lastCell.sectionLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
          self.lastIndex = currentIndex;
     }else if (self.calloutType == CYCalloutViewTypeForNone){
          CYSectionIndexViewCell * currentCell = (CYSectionIndexViewCell *)self.itemViewList[currentIndex];
          CYSectionIndexViewCell * lastCell = [CYSectionIndexViewCell new];
          if (self.lastIndex >= 0) {
               lastCell = (CYSectionIndexViewCell *)self.itemViewList[self.lastIndex];
          }
          currentCell.textLabel.textColor = [UIColor orangeColor];
          lastCell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
          self.lastIndex = currentIndex;
     }
}
#pragma mark- UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.numberItems;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     CYSectionIndexViewCell * cell = [self dequeueSectionIndexCellWithReuseIdentifier:identifierCYSectionIndexViewCell];
     if (self.calloutType == CYCalloutViewTypeForUserDefined && self.dataSource && [self.dataSource respondsToSelector:@selector(sectionIndexView:itemViewForSection:)]) {
          cell = [self.dataSource sectionIndexView:self itemViewForSection:indexPath.row];
     }else if (self.calloutType == CYCalloutViewTypeForWeChat) {
          //微信模式
          CYCustomSectionIndexCell * customCell = (CYCustomSectionIndexCell *)[tableView dequeueReusableCellWithIdentifier:identifierCYCustomSectionIndexCell];
          if (self.dataSource && [self.dataSource respondsToSelector:@selector(sectionIndexView:titleForSection:)]) {
               NSString * text = [self.dataSource sectionIndexView:self titleForSection:indexPath.row];
               customCell.sectionLabel.text = text ? text : @"";
               CGFloat sectionIndexItemH = [self sectionIndexItemHeightByItems:self.numberItems];
               customCell.sectionLabel.layer.cornerRadius = sectionIndexItemH * 0.5;
               customCell.sectionLabel.layer.masksToBounds = YES;
          }
          cell = customCell;
     }else{
          //初始模式
          cell.textLabel.font = [UIFont systemFontOfSize:10];
          if (self.dataSource && [self.dataSource respondsToSelector:@selector(sectionIndexView:titleForSection:)]) {
               NSString * text = [self.dataSource sectionIndexView:self titleForSection:indexPath.row];
               cell.textLabel.text = text ? text : @"";
          }
     }
     cell.section = indexPath.row;
     cell.backgroundColor = [UIColor clearColor];
     cell.contentView.backgroundColor = [UIColor clearColor];
     [self.itemViewList addObject:cell];
     return cell;
}
#pragma mark methods of touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     UITouch *touch = [touches anyObject];
     CGPoint touchPoint = [touch locationInView:self.sectionIndexTableView];
     self.isTouch = YES;
     for (CYSectionIndexViewCell *cell in self.sectionIndexTableView.visibleCells) {
          if (CGRectContainsPoint(cell.frame, touchPoint)) {
               if (cell.section != self.selectIndex) {
                    self.selectIndex = cell.section;
                    [self selectItemViewForSection:self.selectIndex andCellRect:cell.frame];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionIndexView:didSelectSection:)]) {
                         [self.delegate sectionIndexView:self didSelectSection:self.selectIndex];
                    }
               }
               return;
          }
     }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
     UITouch *touch = [touches anyObject];
     CGPoint touchPoint = [touch locationInView:self.sectionIndexTableView];
     for (CYSectionIndexViewCell *cell in self.sectionIndexTableView.visibleCells) {
          if (CGRectContainsPoint(cell.frame, touchPoint)) {
               if (cell.section != self.selectIndex) {
                    self.selectIndex = cell.section;
                    [self selectItemViewForSection:self.selectIndex andCellRect:cell.frame];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionIndexView:didSelectSection:)]) {
                         [self.delegate sectionIndexView:self didSelectSection:self.selectIndex];
                    }
               }
               return;
          }
     }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self hidenCalloutView];
     if (self.delegate && [self.delegate respondsToSelector:@selector(sectionIndexView:didEndSelectSection:)]) {
          [self.delegate sectionIndexView:self didEndSelectSection:self.selectIndex];
     }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self touchesCancelled:touches withEvent:event];
}
@end
