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
@interface ChartView()
{
    NSMutableArray * _pointArray;
}
@end

@implementation ChartView

-(instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.lineColor = [UIColor grayColor];
        self.ShowDashed = NO;
        self.animated = NO;
        self.maxValueOfYAxis = 1;
        self.minValueOfYAxis = 0;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextSetLineWidth(context, kStrokeWidth);
    
    //draw setup
    [self drawCoorinateAxis:context];
    
    [self drawTextOnXAxis:context];
    
    [self drawPoints:context];
    
    [self drawLines:context];
}

#pragma mark
-(void)drawPoints:(CGContextRef)context
{
    _pointArray = [NSMutableArray array];
    
    for (int i = 0; i < self.coordinateItems.count; i++)
    {
        
        CoordinateItem *item = self.coordinateItems[i];
        
        CGFloat x = kXAxisSpace * i + kChartViewEdgeOfHorizontal;
        CGFloat y = kChartViewEdgeOfVertical + (1-[item.yValue floatValue]/self.maxValueOfYAxis) * (self.frame.size.height - 2*kChartViewEdgeOfVertical);
        
        [_pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        
        //画点
        CGContextFillEllipseInRect(context, CGRectMake(x - kCirclePointWidth/2, y - kCirclePointWidth/2, kCirclePointWidth, kCirclePointWidth));
    }
}

-(void)drawCoorinateAxis:(CGContextRef)context
{
    const CGPoint points[] = {
        CGPointMake(kChartViewEdgeOfHorizontal, kChartViewEdgeOfVertical),
        CGPointMake(kChartViewEdgeOfHorizontal, self.frame.size.height - kChartViewEdgeOfVertical),
        CGPointMake(self.frame.size.width - kChartViewEdgeOfHorizontal, self.frame.size.height - kChartViewEdgeOfVertical)
    };
    
    CGContextAddLines(context, points, sizeof(points)/sizeof(points[0]));
    
    CGContextStrokePath(context);
    
    

    //draw arrow
    const CGFloat arrowNum = 7;
    
    //X
    const CGPoint pointsOfXAxis[] = {
        CGPointMake(kChartViewEdgeOfHorizontal - arrowNum, kChartViewEdgeOfVertical + arrowNum),
        CGPointMake(kChartViewEdgeOfHorizontal, kChartViewEdgeOfVertical),
        CGPointMake(kChartViewEdgeOfHorizontal + arrowNum, kChartViewEdgeOfVertical + arrowNum)
    };
    CGContextAddLines(context, pointsOfXAxis, sizeof(pointsOfXAxis)/sizeof(pointsOfXAxis[0]));
    CGContextStrokePath(context);
    
    //Y
    const CGPoint pointsOfYAxis[] = {
        CGPointMake(self.frame.size.width - kChartViewEdgeOfHorizontal - arrowNum, self.frame.size.height - kChartViewEdgeOfVertical - arrowNum),
        CGPointMake(self.frame.size.width - kChartViewEdgeOfHorizontal, self.frame.size.height - kChartViewEdgeOfVertical),
        CGPointMake(self.frame.size.width - kChartViewEdgeOfHorizontal - arrowNum, self.frame.size.height - kChartViewEdgeOfVertical + arrowNum)
    };
    CGContextAddLines(context, pointsOfYAxis, sizeof(pointsOfYAxis)/sizeof(pointsOfYAxis[0]));
    CGContextStrokePath(context);
    
    //draw dash
    if (self.ShowDashed)
    {
        CGFloat lengths[] = {5, 5};
        CGContextSetLineDash(context, 0, lengths, sizeof(lengths)/sizeof(lengths[0]));
        
        CGFloat heightOfYAxisSpace = (self.frame.size.height - 2 * kChartViewEdgeOfVertical )/kNumOfYAxisPoints;
        
        for (int i = 0; i < kNumOfYAxisPoints; i++)
        {
            CGContextMoveToPoint(context, kChartViewEdgeOfHorizontal, kChartViewEdgeOfVertical + i * heightOfYAxisSpace);
            CGContextAddLineToPoint(context,self.frame.size.width - kChartViewEdgeOfHorizontal, kChartViewEdgeOfVertical + i * heightOfYAxisSpace);
            CGContextStrokePath(context);
        }
    }
    
}

-(void)drawTextOnXAxis:(CGContextRef)context
{
    for (int i = 0; i < self.coordinateItems.count; i++)
    {
        CoordinateItem * item = self.coordinateItems[i];
        
        CGFloat x = kChartViewEdgeOfHorizontal + i * kXAxisSpace;
        CGFloat y = self.frame.size.height - kChartViewEdgeOfVertical;
        
        CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
        
        UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:[ UIFont systemFontOfSize:17].fontName matrix:matrix];
        
        UIFont * font = [UIFont fontWithDescriptor:desc size :13];
        
        [item.xValue drawAtPoint:CGPointMake(x, y) withAttributes:@{NSFontAttributeName:font}];
    }
}

-(void)drawLines:(CGContextRef)context
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    [_lineColor setFill];
    
    //画线
    for (int i = 0; i < _pointArray.count - 1; i++)
    {
        //起点
        CGPoint startPoint = [_pointArray[i] CGPointValue];
        //终点
        CGPoint endPoint = [_pointArray[i+1] CGPointValue];
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        //线条宽度
        lineLayer.lineWidth = kLineWidth;
        //线条的颜色
        lineLayer.strokeColor = [_lineColor CGColor];
        [self.layer addSublayer:lineLayer];
        
        //起点
        CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
        CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
        
        //设置路径
        lineLayer.path = path;
        
        
        if (_animated)
        {
            CABasicAnimation *basicAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            basicAni.duration = 6;
            basicAni.fromValue = @(0.0);
            basicAni.toValue = @(1.0);
            
            [lineLayer addAnimation:basicAni forKey:nil];
        }
        
    }
    
    //释放
    CGPathRelease(path);
}

#pragma mark    touch
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint  point = [touch locationInView:self];
    //    NSLog(@"result is %ld",(NSInteger)(point.x - kChartViewEdgeOfHorizontal) % (NSInteger)kXAxisSpace);
    
    if ((NSInteger)(point.x - kChartViewEdgeOfHorizontal) % (NSInteger)kXAxisSpace < kErrorRange || (NSInteger)(point.x - kChartViewEdgeOfHorizontal) % (NSInteger)kXAxisSpace > kXAxisSpace - kErrorRange)
    {
        NSInteger x = (point.x + kErrorRange - kChartViewEdgeOfHorizontal)/kXAxisSpace;
        NSLog(@"x is %ld",(long)x);
        
        CGFloat yValue = [self.coordinateItems[x].yValue doubleValue];
        
        CGFloat Y = kChartViewEdgeOfVertical + (1-yValue/self.maxValueOfYAxis) * (self.frame.size.height - 2*kChartViewEdgeOfVertical);
        
        NSLog(@"Y is %f yValue is %f fabs is %f",point.y,yValue,fabs(yValue - point.x));
        
        if (fabs(Y - point.y) < kErrorRange)
        {
            if (self.pointDidSelectedBlock)
            {
                self.pointDidSelectedBlock(self.coordinateItems[x],CGPointMake(kChartViewEdgeOfHorizontal + x * kXAxisSpace, Y));
            }
        }
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

-(ChartView *)chartView
{
    if (!_chartView)
    {
        _chartView = [[ChartView alloc] init];
        _chartView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_chartView];
    }
    
    return _chartView;
}

-(void)layoutSubviews
{
    self.contentSize = CGSizeMake(MAX(2 * kChartViewEdgeOfHorizontal + (self.chartView.coordinateItems.count - 1) * kXAxisSpace, self.frame.size.width), self.frame.size.height);
    
    _chartView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
}

@end
