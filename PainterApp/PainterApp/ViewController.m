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

-(IBAction) SettingClick
{
    if(pPainterSetupViewController == nil)
    {
        PainterSetupViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PainterSetupViewController"];
        
        viewController.delegate = self;
        pPainterSetupViewController = viewController;
    }
    
    [self presentViewController:pPainterSetupViewController animated:YES completion:nil];
}

-(void)painterSetupViewController:(PainterSetupViewController *)controller setColor:(UIColor *)color
{
    [(MainPainterView *)self.view setCurColor:color];
}

-(void)painterSetupViewController:(PainterSetupViewController *)controller setWidth:(float)width
{
    [(MainPainterView *)self.view setCurWidth:width];
}

@end
