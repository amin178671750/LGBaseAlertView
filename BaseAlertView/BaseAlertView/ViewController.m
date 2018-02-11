//
//  ViewController.m
//  BaseAlertView
//
//  Created by LG on 2018/2/11.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "ViewController.h"
#import "LGBaseTextAlertView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl; /**< 切换器 */

@property (nonatomic, strong) NSArray *enumArray; /**< 选项 */
@property (nonatomic, strong) NSArray *dataArray; /**< 数据源 */

@end

@implementation ViewController

#pragma mark - Super

- (id)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _enumArray = @[
                   @(LGBaseAlertViewStyleEffectExtraLight),
                   @(LGBaseAlertViewStyleEffectLight),
                   @(LGBaseAlertViewStyleEffectDark),
                   @(LGBaseAlertViewStyleEffectRegular),
                   @(LGBaseAlertViewStyleEffectProminent),
                   @(LGBaseAlertViewStyleDark), /**< 正常亮暗风格 */
                   @(LGBaseAlertViewStyleLight), /**< 正常亮风格 */
                   ];
    _dataArray = @[
                   @"轻亮模糊",
                   @"亮模糊",
                   @"暗模糊",
                   @"规则模糊",
                   @"突出模糊",
                   @"正常暗",
                   @"正常亮"
                   ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@"background.jpg"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _tableView.backgroundView = backgroundImageView;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    CGRect headerFrame = frame;
    headerFrame.size.height = 70.0f;
    
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    headerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[
                                                                    @"无动画",
                                                                    @"透明度",
                                                                    @"缩小",
                                                                    @"放大",
                                                                    @"向上"
                                                                    ]];
    [_segmentedControl setFrame:CGRectInset(headerFrame, 10, 10)];
    [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.selectedSegmentIndex = 0;
    [headerView addSubview:_segmentedControl];
    
    _tableView.tableHeaderView = headerView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public

#pragma mark - Data

#pragma mark - UITableViewDataSource、UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

///表格的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3f];
        cell.backgroundView = nil;
        
    }
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    LGBaseTextAlertView *textAlertView = [[LGBaseTextAlertView alloc] initWithFrame:frame alertViewStyle:(LGBaseAlertViewStyle)[[_enumArray objectAtIndex:indexPath.row] integerValue]];
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:0.8f],
                                 };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"2018年，新年快乐，祝您工作顺利，万事如意！" attributes:attributes];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
    [textAlertView setAttributedString:attributedString];
    textAlertView.contentAnimateStyle = (LGBaseContentViewShowAnimateStyle)_segmentedControl.selectedSegmentIndex;
    [textAlertView showInView:nil];
    
}

#pragma mark - Event

//控制按钮点击方法
- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl
{
    NSLog(@"当前选择的切换按钮是：%@",@(segmentedControl.selectedSegmentIndex));
}

#pragma mark - Private



#pragma mark - Getters and setters




@end
