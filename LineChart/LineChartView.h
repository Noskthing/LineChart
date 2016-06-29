//
//  LineChartView.h
//  LineChart
//
//  Created by 李博文 on 16/6/21.
//  Copyright © 2016年 李博文. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark CoordinatePoint
@interface CoordinateItem : NSObject

/**
 *  X value
 */
@property (nonatomic, copy) NSString *xValue;

/**
 *  Y value
 */
@property (nonatomic, copy) NSString *yValue;

+ (instancetype)coordinateItemWithXValue:(NSString *)xValue yValue:(NSString *)yValue;

@end

#pragma mark ChartView
/**
 *  called when points be touched
 *
 *  @param CoordinateItem value of point which is touched
 */
typedef void(^PointDidSelectedBlock)(CoordinateItem * coordinateItem,CGPoint location);

@interface ChartView : UIView
/**
 *  default is NO
 */
@property (nonatomic, assign) BOOL ShowDashed;


@property (nonatomic, strong) NSArray <CoordinateItem *>*coordinateItems;

/**
 *  default is grayColor
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  default is NO
 */
@property (nonatomic, assign) BOOL animated;

/**
 *  default is 1
 */
@property (nonatomic,assign)CGFloat maxValueOfYAxis;

/**
 *  default is 0
 */
@property (nonatomic,assign)CGFloat minValueOfYAxis;

/**
 *  can be nil
 */
@property (nonatomic,copy)PointDidSelectedBlock pointDidSelectedBlock;

@end

#pragma mark LineChartView
@interface LineChartView : UIScrollView

@property (nonatomic,strong)ChartView * chartView;

@end
