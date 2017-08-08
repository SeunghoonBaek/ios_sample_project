
#import <UIKit/UIKit.h>


@interface MeterGaugeView : UIView {
	
	CGImageRef imgGauge;
    
    
    double  value;
}


//-(void) drawLine:(CGContextRef)context;
-(void) drawGaugeBitmap:(CGContextRef)context;
//-(void) DrawValue:(CGContextRef)context CenterX:(int)pCenterX  CenterY:(int)CenterY;


@property  double value;


@end
