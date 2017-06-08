//
//  ViewController.m
//  PainterApp
//
//  Created by baek on 2017. 6. 7..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)PenClick
{
    [(MainPainterView *)self.view setCurType:PEN];
}

-(IBAction)LineClick
{
    [(MainPainterView *)self.view setCurType:LINE];
}
-(IBAction)CircleClick
{
    [(MainPainterView *)self.view setCurType:CIRCLE];
}

-(IBAction)EraseClick
{
    [(MainPainterView *)self.view setCurType:ERASE];
}

-(IBAction)RectClick
{
    [(MainPainterView *)self.view setCurType:RECT];
}


@end
