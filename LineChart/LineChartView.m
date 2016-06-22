//
//  LineChartView.m
//  LineChart
//
//  Created by 李博文 on 16/6/21.
//  Copyright © 2016年 李博文. All rights reserved.
//

#import "LineChartView.h"
#import "ConstConfig.h"

@implementation CoordinateItem

+ (instancetype)coordinateItemWithXValue:(NSString *)xValue yValue:(NSString *)yValue
{
    CoordinateItem *item = [[self alloc] init];
    item.xValue = xValue;
    item.yValue = yValue;
    
    return item;
}

@end

#pragma mark
@interface ChartView : UIView

@property (nonatomic, strong) NSArray *coordinateItems;

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, assign) BOOL animated;

@property (nonatomic, assign) BOOL ShowDashed;
@end

@implementation ChartView

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextSetLineWidth(context, kStrokeWidth);
    
    //draw Coordinate axis
    [self drawCoorinateAxis:context];
    
    //draw text
    [self drawTextOnXAxis:context];
    
}

#pragma mark
-(void)drawCoorinateAxis:(CGContextRef)context
{
    const CGPoint points[] = {
        CGPointMake(kChartViewEdgeOfHorizontal, kChartViewEdgeOfVertical),
        CGPointMake(kChartViewEdgeOfHorizontal, self.frame.size.height - kChartViewEdgeOfVertical),
        CGPointMake(self.frame.size.width - kChartViewEdgeOfVertical, self.frame.size.height - kChartViewEdgeOfVertical)
    };
    
    CGContextAddLines(context, points, sizeof(points)/sizeof(points[0]));
    
    CGContextStrokePath(context);
    
    if (self.ShowDashed)
    {
        CGFloat lengths[] = {5, 5};
        CGContextSetLineDash(context, 0, lengths, sizeof(lengths)/sizeof(lengths[0]));
        
        CGFloat heightOfYAxisSpace = (self.frame.size.height - 2 * kChartViewEdgeOfVertical )/kNumOfYAxisPoints;
        
        for (int i = 0; i < kNumOfYAxisPoints; i++)
        {
            CGContextMoveToPoint(context, kChartViewEdgeOfHorizontal, kChartViewEdgeOfVertical + i * heightOfYAxisSpace);
            CGContextAddLineToPoint(context,self.frame.size.width - kChartViewEdgeOfHorizontal * 2, kChartViewEdgeOfVertical + i * heightOfYAxisSpace);
            CGContextStrokePath(context);
        }
    }
    
}

#pragma mark
-(void)drawTextOnXAxis:(CGContextRef)context
{
    for (int i = 0; i < self.coordinateItems.count; i++)
    {
        CoordinateItem * item = self.coordinateItems[i];
        
        CGFloat x = kChartViewEdgeOfHorizontal + i * kXAxisSpace;
        CGFloat y = self.frame.size.height - kChartViewEdgeOfVertical;
        
        CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
        
        UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize :17 ]. fontName matrix :matrix];
        
        UIFont * font = [UIFont fontWithDescriptor:desc size :17];
        
        [item.xValue drawAtPoint:CGPointMake(x, y) withAttributes:@{NSFontAttributeName:font}];
    }
}
@end


#pragma mark

@interface LineChartView ()
{
    ChartView * _chartView;
}
@end

@implementation LineChartView
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

-(void)drawLineChartView
{
    _chartView = [[ChartView alloc] init];
    _chartView.backgroundColor = [UIColor whiteColor];
    
    _chartView.coordinateItems = self.coordinateItems;
    _chartView.lineColor = self.lineColor?self.lineColor:[UIColor grayColor];
    _chartView.animated = self.animated;
    _chartView.ShowDashed = self.ShowDashed;
    
    [self addSubview:_chartView];
}

-(void)layoutSubviews
{
    self.contentSize = CGSizeMake(MAX(2 * kChartViewEdgeOfHorizontal + _coordinateItems.count * kXAxisSpace, self.frame.size.width), self.frame.size.height);
    
    _chartView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
}

@end
