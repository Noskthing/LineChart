//
//  ViewController.m
//  LineChart
//
//  Created by 李博文 on 16/6/21.
//  Copyright © 2016年 李博文. All rights reserved.
//

#import "ViewController.h"
#import "LineChartView.h"
@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    LineChartView * lineChartView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    
    lineChartView.backgroundColor = [UIColor greenColor];
    lineChartView.chartView.coordinateItems = self.dataSourceArray;
    lineChartView.chartView.ShowDashed = YES;
    lineChartView.chartView.lineColor = [UIColor grayColor];
    lineChartView.chartView.maxValueOfYAxis = 100;
    lineChartView.chartView.animated = YES;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    view.backgroundColor = [UIColor redColor];
    [lineChartView addSubview:view];
    
    lineChartView.chartView.pointDidSelectedBlock = ^(CoordinateItem * coordinateItem,CGPoint location){
        NSLog(@"aaaaa");
        view.layer.position = location;
    };
    
    [self.view addSubview:lineChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray)
    {
        _dataSourceArray = [NSMutableArray array];
        
        NSArray *yValues = @[@"5",@"30",@"20",@"35",@"55",@"25",@"45",@"85",@"15",@"35"];
        
        for (int i = 0; i < 10; i++)
        {
            CoordinateItem *item = [CoordinateItem coordinateItemWithXValue:[NSString stringWithFormat:@"%d",i] yValue:yValues[i]];
            
            [_dataSourceArray addObject:item];
            
        }
    }
    
    return _dataSourceArray;
}

@end
