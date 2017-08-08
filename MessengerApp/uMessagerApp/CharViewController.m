//
//  CharViewController.m
//  uMessageApp
//
//  Created by 소영섭 on 13. 2. 3..
//  Copyright (c) 2013년 소영섭. All rights reserved.
//

#import "CharViewController.h"
#import "ChatDataModel.h"
#import "ChatViewCell.h"
#import "NetWorkController.h"


#define WIDTH_SPACE             100.f     // 가로 넓이'
#define RIGHT_WIDTH_SPACE       58.0f    // 오른쪽 여유공간 


@implementation CharViewController

@synthesize  pBackView;
@synthesize  pTextView;
@synthesize  pButton;
@synthesize  pChatListView;
@synthesize  pNetWorkController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    [super viewDidLoad];
}

//status bar를안보이게합니다.
- (BOOL)prefersStatusBarHidden
{
    return YES;
    
}

- (void)sendText
{
    [pTextView resignFirstResponder];   //키보드 감추기
    [pNetWorkController SendChatTextCommand];      // 네트워크를 통해 메시지 전송
    
}


-(void)keyboardWillShow:(NSNotification *)pNotification
{
    
    CGRect pFrame = pBackView.frame;
    
    NSDictionary *userInfo = [pNotification userInfo];
    
    CGRect bound;
    
    [(NSValue *) [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&bound];
    
    pFrame.origin.y -= bound.size.height;
    
    pBackView.frame = pFrame;
    
}

- (void)keyboardWillHide:(NSNotification*)pNotification
{
    
    CGRect pFrame = pBackView.frame;
    
    NSDictionary *userInfo = [pNotification userInfo];
    
    CGRect bound;
    
    [(NSValue *) [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&bound];
    
    pFrame.origin.y += bound.size.height;
    
    pBackView.frame = pFrame;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark 테이블 뷰 델리게이트

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (pNetWorkController.pChatData == nil)
        return 0;
    else return [pNetWorkController.pChatData count];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatDataModel *rowData = [pNetWorkController.pChatData objectAtIndex:[indexPath row]];
    CGSize dataSize = [self getBoxSize:rowData.pContext];
    

    return dataSize.height + 30;
}

// 대화상자 풍선도움말 크기를 구합니다.
- (CGSize)getBoxSize:(NSString *)string {
    CGSize maxSize = CGSizeMake(170.0, 1000.0);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize: 14], NSFontAttributeName,
                                          [UIColor blackColor], NSForegroundColorAttributeName,
                                          nil];
    CGRect text_size = [string boundingRectWithSize:maxSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributesDictionary
                                           context:nil];
    
    return CGSizeMake(text_size.size.width + 10, text_size.size.height);
}




- (ChatViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *cellArray= [[NSBundle mainBundle] loadNibNamed:@"ChatViewCell" owner:self options:nil];
    ChatViewCell *cell = nil;

    
    ChatDataModel *rowData = [pNetWorkController.pChatData objectAtIndex:[indexPath row]];
    CGSize dataSize = [self getBoxSize:rowData.pContext];
    
    
    CGSize windowSize = self.pChatListView.frame.size;
    
    if (rowData.LeftYN )
    {
        
        
        cell = [cellArray objectAtIndex:0];
        
        cell.pBackImageView.image = [[UIImage imageNamed:@"box.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
        
        cell.pBackImageView.frame = CGRectMake(
                                               cell.pBackImageView.frame.origin.x,
                                               cell.pBackImageView.frame.origin.y,
                                               MAX(dataSize.width, WIDTH_SPACE)+5, dataSize.height);
        
        cell.pContextView.frame = CGRectMake(
                                             cell.pContextView.frame.origin.x,
                                             cell.pContextView.frame.origin.y,
                                             MAX(dataSize.width, WIDTH_SPACE - 10.0), dataSize.height);
        
    }
    else
    {
        
        cell = [cellArray objectAtIndex:1];
        
        cell.pBackImageView.image = [[UIImage imageNamed:@"tar_box.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];

        cell.pBackImageView.frame = CGRectMake(
                                               windowSize.width - RIGHT_WIDTH_SPACE - MAX(dataSize.width, WIDTH_SPACE)+5,
                                               cell.pBackImageView.frame.origin.y,
                                               MAX(dataSize.width, WIDTH_SPACE)+5, dataSize.height);
        
        cell.pContextView.frame = CGRectMake(
                                             windowSize.width - RIGHT_WIDTH_SPACE - MAX(dataSize.width, WIDTH_SPACE)+5,
                                             cell.pContextView.frame.origin.y,
                                             MAX(dataSize.width, WIDTH_SPACE - 10.0), dataSize.height);
        

    }
    cell.pTimeView.text = rowData.pTime;
    cell.pContextView.text = rowData.pContext;
    
    return cell;
    
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


-(IBAction)CloseClick
{
    [pNetWorkController SendCloseChatTextCommand];   // 프로젝트 파일에만 추가됨.
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark -
#pragma mark Table view delegate


@end
