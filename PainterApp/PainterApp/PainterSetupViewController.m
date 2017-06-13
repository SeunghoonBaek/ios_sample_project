//
//  PainterSetupViewController.m
//  PainterApp
//
//  Created by baek on 2017. 6. 14..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "PainterSetupViewController.h"

@implementation PainterSetupViewController

@synthesize delegate;

-(IBAction) ValueChange:(id)sender
{
    UIColor* tColor = [[UIColor alloc] initWithRed:[self.redBar value] green:[self.greenBar value] blue:[self.blueBar value] alpha:1.0f];
    
    [self.colorPreview setBackgroundColor:tColor];
}

-(IBAction) PushBackClick
{
    UIColor* tColor = [[UIColor alloc] initWithRed:[self.redBar value] green:[self.greenBar value] blue:[self.blueBar value] alpha:1.0f];
    
    [delegate painterSetupViewController:self setColor:tColor];
    [delegate painterSetupViewController:self setWidth:[self.widthBar value]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
