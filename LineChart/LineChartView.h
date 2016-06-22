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

#pragma mark LineChartView
@interface LineChartView : UIScrollView
/**
 *  default is NO
 */
@property (nonatomic, assign) BOOL ShowDashed;


@property (nonatomic, strong) NSArray *coordinateItems;
/**
 *  default is grayColor
 */
@property (nonatomic, strong) UIColor *lineColor;
/**
 *  default is NO
 */
@property (nonatomic, assign) BOOL animated;

/**
 *  frame can not be nil
 */
-(void)drawLineChartView;

@end
