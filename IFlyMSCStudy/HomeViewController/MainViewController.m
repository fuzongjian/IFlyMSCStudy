//
//  MainViewController.m
//  IFlyMSCStudy
//
//  Created by 付宗建 on 17/2/13.
//  Copyright © 2017年 youran. All rights reserved.
//

#import "MainViewController.h"
#import "ListenVoiceController.h"
#import "VoiceRecognitionController.h"
#import "VoiceSynthesisController.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * titleArray;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configMainViewControllerUI];
}
- (void)configMainViewControllerUI{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleLabel.text = @"科大讯飞语音识别";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellID = @"MianCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.textLabel.text= [self.titleArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController * nextController;
    switch (indexPath.row) {
        case 0:
            nextController = [[ListenVoiceController alloc] init];
            break;
        case 1:
            nextController = [[VoiceRecognitionController alloc] init];
            break;
        case 2:
            nextController = [[VoiceSynthesisController alloc] init];
            break;
        default:
            break;
    }
    nextController.title = [self.titleArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:nextController animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSArray arrayWithObjects:@"语音听写",@"语音识别",@"语音合成",@"语义理解",@"本地功能集成",@"语音评测",
                       @"语音唤醒",@"声纹识别",@"人脸识别",nil];
    }
    return _titleArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
