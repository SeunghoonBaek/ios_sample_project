//
//  ViewController.m
//  ImageProcessing
//
//  Created by baek on 2017. 7. 28..
//  Copyright © 2017년 baek. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize pImageProcInfoViewController;

- (void)viewDidLoad {
    pImageProcessing = [[ImageProcessing alloc] init];
    orginImage = [UIImage imageNamed:@"default.png"];
    [pImageView setImage:orginImage];
    [super viewDidLoad];
}

- (BOOL) prefersStatusBarHidden{
    return YES;
}

-(IBAction) PushSetupClick{
    if(pImageProcInfoViewController == nil){
        ImageProcInfoViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageProcInfoViewController"];
        
        pImageProcInfoViewController = viewController;
    }
    
    [self presentViewController:pImageProcInfoViewController animated:YES completion:nil];
}

-(IBAction) runGeneralPicker{
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void) finishedPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    orginImage = nil;
    orginImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self finishedPicker];
    [pImageView setImage:orginImage];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self finishedPicker];
}

-(IBAction)WhiteBlackImage{
    pImageView.image = [[[pImageProcessing setImage:orginImage] getGrayImage] getImage];
}

-(IBAction) InverseImage{
    pImageView.image = [[[pImageProcessing setImage:orginImage] getInverseImage] getImage];
}

-(IBAction) TrackingImage{
    pImageView.image = [[[pImageProcessing setImage:orginImage] getTrackingImage] getImage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
