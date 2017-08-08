//
//  SetupViewController.h
//  uMessageApp
//
//  Created by 소영섭 on 13. 2. 3..
//  Copyright (c) 2013년 소영섭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface SetupViewController : UIViewController


-(IBAction) LogIn;     // 로그인 요청

@property(weak, nonatomic) IBOutlet UITextField  *pUserIDField;
@property(weak, nonatomic) IBOutlet UITextField  *pPassField;

@property(strong, nonatomic) ViewController *pRootViewController;

@end
