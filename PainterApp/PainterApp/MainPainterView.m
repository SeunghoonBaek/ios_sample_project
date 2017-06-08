//
//  MainPainterView.m
//  PainterApp
//
//  Created by baek on 2017. 6. 7..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "MainPainterView.h"

@implementation MainPainterView

@synthesize curPointData;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self == [super initWithCoder:aDecoder])
    {
        pPointArray = [[NSMutableArray alloc] init];
        pCurColor = [UIColor blackColor];
        pCurWidth = 2.0f;
        pCurType = PEN;
        [self initCurPointData];
    }
    
    return self;
}

-(void) initCurPointData
{
    curPointData = [[PointData alloc] init];
    [curPointData setPColor:pCurColor];
    [curPointData setPWidth:pCurWidth];
    [curPointData setPType:pCurType];
}

-(void) setCurType:(TYPES)type
{
    pCurType = type;
    [curPointData setPType:type];
}

-(void) setCurColre:(UIColor *)color
{
    pCurColor = color;
    [curPointData setPColor:color];
}

-(void) setCurWidth:(float)width
{
    pCurWidth = width;
    [curPointData setPWidth:width];
}

-(void) addPointArray
{
    [pPointArray addObject:curPointData];
    [self initCurPointData];
}

-(void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(PointData* pPoint in pPointArray)
    {
        [self drawScreen:pPoint inContext:context];
    }
    
    [self drawScreen:curPointData inContext:context];
}

-(void) drawScreen:(PointData *)pData inContext:(CGContextRef)context
{
    switch(pData.pType)
    {
        case PEN :
            [self drawPen:pData inContext:context];
            break;
            
        case LINE :
            [self drawLine:pData inContext:context];
            break;
            
        case CIRCLE :
            [self drawCircle:pData inContext:context];
            break;
            
        case RECT :
            [self drawFillRect:pData inContext:context];
            break;
            
        case ERASE :
            [self drawErase:pData inContext:context];
            break;
            
        default :
            break;
    }
}

-(void) drawPen:(PointData *)pData inContext:(CGContextRef)context
{
    CGColorRef colorRef = [pData.pColor CGColor];
    CGContextSetStrokeColorWithColor(context, colorRef);
    
    CGContextSetLineWidth(context, pData.pWidth);
    NSMutableArray* points = [pData points];
    if(points.count == 0)
    {
        return;
    }
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGPoint firstPoint;
    [[points objectAtIndex:0] getValue:&firstPoint];
    
    // Set starting point
    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
    for(int i = 1 ; i < [points count] ; i++)
    {
        NSValue* value = [points objectAtIndex:i];
        CGPoint point;
        
        [value getValue:&point];
        CGContextAddLineToPoint(context, point.x, point.y); // Move next position
    }
    
    CGContextStrokePath(context); // Draw line following position
}

-(void) drawLine:(PointData *)pData inContext:(CGContextRef)context
{
    CGColorRef colorRef = [pData.pColor CGColor];
    CGContextSetStrokeColorWithColor(context, colorRef);
    
    CGContextSetLineWidth(context, pData.pWidth);
    NSMutableArray* points = [pData points];
    
    if(points.count == 0)
    {
        return;
    }
    
    CGPoint firstPoint;
    [[points objectAtIndex:0] getValue:&firstPoint];
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
    
    CGPoint lastPoint;
    [[points objectAtIndex:points.count - 1]getValue:&lastPoint];
    
    CGContextAddLineToPoint(context, lastPoint.x, lastPoint.y);
    CGContextStrokePath(context);
}

-(void) drawCircle:(PointData *)pData inContext:(CGContextRef)context
{
    CGColorRef colorRef = [pData.pColor CGColor];
    CGContextSetStrokeColorWithColor(context, colorRef);
    
    CGContextSetLineWidth(context, pData.pWidth);
    
    NSMutableArray* points = [pData points];
    if(points.count == 0)
    {
        return;
    }
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGPoint firstPoint;
    [[points objectAtIndex:0] getValue:&firstPoint];
    
    CGPoint lastPoint;
    [[points objectAtIndex: points.count - 1] getValue:&lastPoint];
    
    CGContextStrokeEllipseInRect(context, CGRectMake(firstPoint.x, firstPoint.y, lastPoint.x - firstPoint.x, lastPoint.y - firstPoint.y));
    CGContextStrokePath(context);
}

-(void) drawErase:(PointData *)pData inContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 10.0f);
    NSMutableArray* points = [pData points];
    
    if(points.count == 0)
    {
        return;
    }
    
    CGPoint firstPoint;
    [[points objectAtIndex:0] getValue:&firstPoint];
    CGContextSetBlendMode(context, kCGBlendModeClear);
    
    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
    for(int i = 1; i < [points count] ; i++)
    {
        NSValue* value = [points objectAtIndex:i];
        CGPoint point;
        [value getValue:&point];
        
        CGContextAddLineToPoint(context, point.x, point.y);
    }
    
    CGContextStrokePath(context);
}

-(void) drawFillRect:(PointData *)pData inContext:(CGContextRef)context
{
    CGColorRef colorRef = [pData.pColor CGColor];
    CGContextSetStrokeColorWithColor(context, colorRef);
    CGContextSetFillColorWithColor(context, colorRef);
    
    NSMutableArray* points = [pData points];
    if(points.count == 0)
    {
        return;
    }
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGPoint firstPoint;
    [[points objectAtIndex:0] getValue:&firstPoint];
    
    CGPoint lastPoint;
    [[points objectAtIndex:points.count - 1] getValue: &lastPoint];
    
    CGContextFillRect(context, CGRectMake(firstPoint.x, firstPoint.y, lastPoint.x - firstPoint.x, lastPoint.y - firstPoint.y));
    
    CGContextStrokePath(context);
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray* array = [touches allObjects];
    for(UITouch* touch in array)
    {
        [curPointData addPoint:[touch locationInView:self]];
    }
    
    [self setNeedsDisplay];
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray* array = [touches allObjects];
    
    for(UITouch* touch in array)
    {
        [curPointData addPoint:[touch locationInView:self]];
    }
    
    [self setNeedsDisplay];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray* array = [touches allObjects];
    
    for(UITouch* touch in array)
    {
        [curPointData addPoint:[touch locationInView:self]];
    }
    
    [self addPointArray];
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
