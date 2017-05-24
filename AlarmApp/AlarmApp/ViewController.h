//
//  ViewController.h
//  AlarmApp
//
//  Created by baek on 2017. 3. 7..
//  Copyright © 2017년 baek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton* infoButton;
@property (strong, nonatomic) MainViewController* mainViewController;
@end

