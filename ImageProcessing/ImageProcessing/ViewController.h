//
//  ViewController.h
//  ImageProcessing
//
//  Created by baek on 2017. 7. 28..
//  Copyright © 2017년 baek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageProcInfoViewController.h"
#import "ImageProcessing.h"

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    ImageProcInfoViewController* pImageProcInfoViewController;
    IBOutlet UIButton* infoButton;
    IBOutlet UIImageView* pImageView;
    
    ImageProcessing* pImageProcessing;
    UIImage* orginImage;
}

-(IBAction) PushSetupClick;
-(IBAction) runGeneralPicker;
-(IBAction) WhiteBlackImage;
-(IBAction) InverseImage;
-(IBAction) TrackingImage;

@property (strong, nonatomic) ImageProcInfoViewController* pImageProcInfoViewController;

@end

