//
//  MainView.m
//  Created by young soeb on 10. 9. 6..
//  Copyright 2010 home. All rights reserved.
//

#import "MeterGaugeView.h"


#define GAUGE_WIDTH		70      // 계기침 길이
#define LINE_WIDTH		3       // 계기침 폭

#define STARTANGLE      225     // 오디오 최저 체벨일 때 계기침 각도
#define ENDANGLE        135     // 오디오 최고 레벨일때 계기침 각도

@implementation MeterGaugeView

@synthesize value;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
    UIImage *img = [UIImage imageNamed:@"gauge.png"];
    imgGauge = CGImageRetain(img.CGImage);
    
//    [img release];
    
	return self;
}

- (void)drawRect:(CGRect)rect {
    
    int StartX = self.bounds.size.width / 2;    //계기침 시작 중심 X 좌표
    int StartY = self.bounds.size.height / 2 + 20;      // 계기침 시작 중심 Y좌표
    int newX, newY;    // 계기침 삼각형의 꼭짓점 X, Y 좌표
    int newStartX1, newStartX2;      // 계기침 삼각혀 좌/우 점의 X좌표
    int newStartY1, newStartY2;      // 계기침 삼각형 좌/우 정의 Y좌표
    int newValue, newValue1, newValue2;

    CGContextRef context = UIGraphicsGetCurrentContext();      // 그래픽 컨텍스트
	[self drawGaugeBitmap:context];

    if(value >= 0.5)
        newValue = ENDANGLE * 2 * (value - 0.5);               // 삼각형 계기침의 좌표를 계산합니다.
    else newValue = STARTANGLE + (360 - STARTANGLE) * 2 * value;

  //  NSLog(@"%f  %d", value, newValue);
	if(newValue - 90 >= 0) newValue1 = newValue - 90;
    else newValue1 = newValue - 90 + 360;
	
    if(newValue + 90 <= 360) newValue2 = newValue + 90;
    else newValue2 = newValue + 90 - 360;
    
    
    newX = (int)(sin(newValue * 3.14/180 ) * GAUGE_WIDTH + StartX);
    newStartX1 = (int)(sin(newValue1 * 3.14/180 ) * LINE_WIDTH + StartX);
    newStartX2 = (int)(sin(newValue2 * 3.14/180 ) * LINE_WIDTH + StartX);
    
    
	newY = (int)(StartY - (cos(newValue * 3.14/180 ) * GAUGE_WIDTH ) );
	newStartY1 = (int)(StartY - (cos(newValue1 * 3.14/180 ) * LINE_WIDTH ) );
	newStartY2 = (int)(StartY - (cos(newValue2 * 3.14/180 ) * LINE_WIDTH ) );
    
    
	//  삼각형 계기침을 그립니다.
    CGContextSetRGBFillColor(context, 1.0, 0, 0, 1.0);
	
    CGContextMoveToPoint(context, newStartX1, newStartY1);
	CGContextAddLineToPoint(context, newStartX2, newStartY2);
	CGContextAddLineToPoint(context, newX, newY);
    CGContextAddLineToPoint(context, newStartX1, newStartY1);
    
    CGContextFillPath(context);
    
}

/*

- (void)dealloc {
	CGImageRelease(imgGauge);

}
 
*/

-(void) drawGaugeBitmap:(CGContextRef)context {
	// CTM의 이전 상태를 저장.
    
	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGContextClipToRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
	CGContextDrawImage(context,CGRectMake(0,0,CGImageGetWidth(imgGauge), CGImageGetHeight(imgGauge)), imgGauge);

	CGContextRestoreGState(context);
}


@end
