//
//  ViewController.h
//  uMessagerApp
//
//  Created by 소영섭 on 2015. 11. 24..
//  Copyright © 2015년 소영섭. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@class MemberListViewController;
@class SetupViewController;

@interface ViewController : UITabBarController < UITabBarControllerDelegate>

-(void)LogIn:(NSString *)pUserID  PassWord:(NSString *)pPass;

@property (strong, nonatomic) MemberListViewController *pMemberListViewController;
@property (strong, nonatomic) SetupViewController      *pSetupViewController;
@property (strong, nonatomic) NSString      *UserID;
@end

