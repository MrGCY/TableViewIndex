//
//  ViewController.m
//  TableViewIndexProject
//
//  Created by Mr.GCY on 2018/8/21.
//  Copyright © 2018年 Mr.GCY. All rights reserved.
//

#import "ViewController.h"
#import "CYListViewController.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray * dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
     [super viewDidLoad];
     self.title = @"索引模式选择";
     self.dataArray = @[@"默认模式",@"微信模式",@"用户自定义模式"];
}
#pragma mark UITableViewDataSource && delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *identifier = @"IdentifierCell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
     if (cell == nil) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
     }
     cell.textLabel.text = self.dataArray[indexPath.row];
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     CYListViewController * listVC = [CYListViewController new];
     listVC.calloutType = indexPath.row;
     listVC.title = self.dataArray[indexPath.row];
     [self.navigationController pushViewController:listVC animated:YES];
     
}

@end
