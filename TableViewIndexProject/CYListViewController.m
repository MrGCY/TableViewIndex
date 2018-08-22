//
//  CYListViewController.m
//  TableViewIndexProject
//
//  Created by Mr.GCY on 2018/8/22.
//  Copyright © 2018年 Mr.GCY. All rights reserved.
//

#import "CYListViewController.h"
#import "CYTextIndexCell.h"
#define identifierCYTextIndexCell @"CYTextIndexCell"
#define kSectionIndexWidth 40.f
#define kSectionIndexHeight 400.f
@interface CYListViewController ()<UITableViewDataSource,UITableViewDelegate,CYSectionIndexViewDelegate,CYSectionIndexViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *sections;
@property (retain, nonatomic) NSMutableDictionary *sectionDic;
@property (nonatomic, strong) CYSectionIndexView * sectionIndexView;
@end

@implementation CYListViewController

- (void)viewDidLoad {
     [super viewDidLoad];
     [self createData];
     self.sectionIndexView = [[CYSectionIndexView alloc] initWithFrame: CGRectMake(CGRectGetWidth(self.view.frame) - kSectionIndexWidth, (CGRectGetHeight(self.view.frame) - kSectionIndexHeight)/2, kSectionIndexWidth, kSectionIndexHeight)];
     [self.sectionIndexView registerNib:[UINib nibWithNibName:identifierCYTextIndexCell bundle:nil] forSectionIndexCellReuseIdentifier:identifierCYTextIndexCell];
     self.sectionIndexView.delegate = self;
     self.sectionIndexView.dataSource = self;
     //     self.sectionIndexView.isShowCallout = NO;
     self.sectionIndexView.calloutType = self.calloutType;
     [self.view addSubview:self.sectionIndexView];
}
#pragma mark UITableViewDataSource && delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [[self.sectionDic objectForKey:[self.sections objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
     return [self.sections objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *identifier = @"IdentifierCell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
     if (cell == nil) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
     }
     cell.textLabel.text = [[self.sectionDic objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)createData
{
     self.sectionDic = [NSMutableDictionary dictionary];
     NSArray *array1 = [NSArray arrayWithObjects:@"apparel",@"apparentness",@"appel",@"appeasement",@"appearance",@"appear",@"appellant",@"apostate",@"appellation",@"aposteriori",@"apospory ", nil];
     NSArray *array2 = [NSArray arrayWithObjects:@"byron",@"SB",nil];
     NSArray *array3 = [NSArray arrayWithObjects:@"cabbage",@"cable",@"cafe", nil];
     NSArray *array4 = [NSArray arrayWithObjects:@"dean",nil];
     NSArray *array5 = [NSArray arrayWithObjects:@"finsh",@"five",@"fine",@"fix", nil];
     NSArray *array6 = [NSArray arrayWithObjects:@"english",@"egg", nil];
     NSArray *array7 = [NSArray arrayWithObjects:@"great",@"gate",@"gif",@"github", nil];
     NSArray *array8 = [NSArray arrayWithObjects:@"hello",@"hungry",@"home",@"house",@"however",@"humble", nil];
     NSArray *array9 = [NSArray arrayWithObjects:@"idea",@"implemention",@"insistt",@"invite", nil];
     NSArray *array10 = [NSArray arrayWithObjects:@"Jack",@"job",@"just", nil];
     NSArray *array11 = [NSArray arrayWithObjects:@"kill",@"king", nil];
     NSArray *array12 = [NSArray arrayWithObjects:@"lucky",@"limit", nil];
     NSArray *array13 = [NSArray arrayWithObjects:@"money",@"much",@"many",@"man",@"million",@"meter",@"may",@"miracle",@"manage",nil];
     NSArray *array14 = [NSArray arrayWithObjects:@"nice",@"nick",@"navigate", nil];
     NSArray *array15 = [NSArray arrayWithObjects:@"ok",@"over",nil];
     NSArray *array16 = [NSArray arrayWithObjects:@"pik",@"pice",@"pizze",nil];
     NSArray *array17 = [NSArray arrayWithObjects:@"quite", nil];
     NSArray *array18 = [NSArray arrayWithObjects:@"request",@"rice",nil];
     NSArray *array19 = [NSArray arrayWithObjects:@"sister",@"sex",@"slider", nil];
     NSArray *array20 = [NSArray arrayWithObjects:@"tool",@"tumb",@"taxi",@"take", nil];
     NSArray *array21 = [NSArray arrayWithObjects:@"unity",@"unless",nil];
     NSArray *array22 = [NSArray arrayWithObjects:@"video",@"vs", nil];
     NSArray *array23 = [NSArray arrayWithObjects:@"world",@"work", nil];
     NSArray *array24 = [NSArray arrayWithObjects:@"XXOO", nil];
     NSArray *array25 = [NSArray arrayWithObjects:@"yellow",@"yet",@"yes",@"yard", nil];
     NSArray *array26 = [NSArray arrayWithObjects:@"zero",@"zike",@"zoom", nil];
     NSArray *array27 = [NSArray arrayWithObjects:@"13579",@"&&&&",@"38",@"250",@"349321810@qq.com",@"码农", nil];
     if (self.calloutType == CYCalloutViewTypeForUserDefined) {
          self.sections = [NSMutableArray arrayWithObjects:@"码",@"农",@"爱",@"旅",@"行",nil];
          [self.sectionDic setObject:array1 forKey:@"码"];
          [self.sectionDic setObject:array2 forKey:@"农"];
          [self.sectionDic setObject:array3 forKey:@"爱"];
          [self.sectionDic setObject:array4 forKey:@"旅"];
          [self.sectionDic setObject:array5 forKey:@"行"];
     }else{
          [self.sectionDic setObject:array1 forKey:@"A"];
          [self.sectionDic setObject:array2 forKey:@"B"];
          [self.sectionDic setObject:array3 forKey:@"C"];
          [self.sectionDic setObject:array4 forKey:@"D"];
          [self.sectionDic setObject:array5 forKey:@"E"];
          [self.sectionDic setObject:array6 forKey:@"F"];
          [self.sectionDic setObject:array7 forKey:@"G"];
          [self.sectionDic setObject:array8 forKey:@"H"];
          [self.sectionDic setObject:array9 forKey:@"I"];
          [self.sectionDic setObject:array10 forKey:@"J"];
          [self.sectionDic setObject:array11 forKey:@"K"];
          [self.sectionDic setObject:array12 forKey:@"L"];
          [self.sectionDic setObject:array13 forKey:@"M"];
          [self.sectionDic setObject:array14 forKey:@"N"];
          [self.sectionDic setObject:array15 forKey:@"O"];
          [self.sectionDic setObject:array16 forKey:@"P"];
          [self.sectionDic setObject:array17 forKey:@"Q"];
          [self.sectionDic setObject:array18 forKey:@"R"];
          [self.sectionDic setObject:array19 forKey:@"S"];
          [self.sectionDic setObject:array20 forKey:@"T"];
          [self.sectionDic setObject:array21 forKey:@"U"];
          [self.sectionDic setObject:array22 forKey:@"V"];
          [self.sectionDic setObject:array23 forKey:@"W"];
          [self.sectionDic setObject:array24 forKey:@"X"];
          [self.sectionDic setObject:array25 forKey:@"Y"];
          [self.sectionDic setObject:array26 forKey:@"Z"];
          [self.sectionDic setObject:array27 forKey:@"#"];
          self.sections = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#",nil];
     }
}
#pragma mark- CYSectionIndexViewDelegate,CYSectionIndexViewDataSource
-(NSInteger)numberOfItemViewForSectionIndexView:(CYSectionIndexView *)sectionIndexView{
     return self.sections.count;
}
- (NSString *)sectionIndexView:(CYSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section{
     return [self.sections objectAtIndex:section];
}
-(CYSectionIndexViewCell *)sectionIndexView:(CYSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section{
     CYTextIndexCell * cell = [sectionIndexView dequeueSectionIndexCellWithReuseIdentifier:identifierCYTextIndexCell];
     cell.indexLabel.text = self.sections[section];
     return cell;
}
- (UIView *)sectionIndexView:(CYSectionIndexView *)sectionIndexView calloutViewForSection:(NSInteger)section
{
     UILabel *label = [[UILabel alloc] init];
     label.frame = CGRectMake(0, 0, 80, 80);
     label.backgroundColor = [UIColor clearColor];
     label.textColor = [UIColor redColor];
     label.font = [UIFont boldSystemFontOfSize:36];
     label.text = [self.sections objectAtIndex:section];
     label.textAlignment = NSTextAlignmentCenter;
     
     [label.layer setCornerRadius:label.frame.size.width/2];
     [label.layer setBorderColor:[UIColor lightGrayColor].CGColor];
     [label.layer setBorderWidth:3.0f];
     [label.layer setShadowColor:[UIColor blackColor].CGColor];
     [label.layer setShadowOpacity:0.8];
     [label.layer setShadowRadius:5.0];
     [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
     return label;
}
-(void)sectionIndexView:(CYSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section{
     [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark-
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
     if (scrollView == self.tableView && !self.sectionIndexView.isTouch) {
          NSArray <UITableViewCell *> *cellArray = [self.tableView  visibleCells];
          //cell的section的最小值
          long cellSectionMINCount = LONG_MAX;
          for (int i = 0; i < cellArray.count; i++) {
               UITableViewCell *cell = cellArray[i];
               long cellSection = [self.tableView indexPathForCell:cell].section;
               if (cellSection < cellSectionMINCount) {
                    cellSectionMINCount = cellSection;
               }
          }
          if (cellSectionMINCount < self.sections.count) {
               [self.sectionIndexView uploadSectionIndexStatusWithCurrentIndex:cellSectionMINCount];
          }
     }
}
@end
