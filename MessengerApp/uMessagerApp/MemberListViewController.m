//
//  MemberListViewController.m
//  uMessageApp
//
//  Created by 소영섭 on 13. 2. 3..
//  Copyright (c) 2013년 소영섭. All rights reserved.
//

#import "MemberListViewController.h"
#import "MemberViewCell.h"
#import "MemberListDataModel.h"
#import "CharViewController.h"
#import "NetWorkController.h"


#define ROW_HEIGHT       50
#define WIDTH_SPACE      75.f     // 가로 여유공가'

@implementation MemberListViewController

@synthesize pListView;
@synthesize pCharViewController;
@synthesize pNetWorkController;


//status bar를안보이게합니다.
- (BOOL)prefersStatusBarHidden
{
    return YES;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"대화상대"; 
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        [self NetWorkInit];
    }
    return self;
}



-(void)ServerConnect:(NSString *)pUserID  PassWord:(NSString *)pPass
{
    // 아이디 및 비밀번호를 설정
    if(pNetWorkController.pStatus) return;
    [pNetWorkController setMyUserInformation:pUserID PassWord:pPass];
    [pNetWorkController getServerConnect];  // 서버 로그인 및 연결
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 테이블 뷰 델리게이트

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (pNetWorkController.pMemeberListdata == nil)
        return 0;
    else return [pNetWorkController.pMemeberListdata count];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}


// 도움말 박스의 크기를 구합니다.
- (CGSize)getBoxSize:(NSString *)string {
    CGSize maxSize = CGSizeMake(180.0, 30);  // 도움말 박스 크기의 최댓값을 설정합니다.
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize: 14], NSFontAttributeName,
                                          [UIColor blackColor], NSForegroundColorAttributeName,
                                          nil];
    CGRect text_size = [string boundingRectWithSize:maxSize
                                            options:NSStringDrawingUsesLineFragmentOrigin //NSStringDrawingUsesFontLeading
                                         attributes:attributesDictionary
                                            context:nil];
    
    return CGSizeMake(text_size.size.width, text_size.size.height);
}




- (MemberViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MemberViewCell";
    
    MemberViewCell *cell = (MemberViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MemberLisDataModel *rowData = [pNetWorkController.pMemeberListdata objectAtIndex:[indexPath row]];
    // 대화내용의 도움말 박스의 크기를 구합니다.
    CGSize dataSize = [self getBoxSize:rowData.pContext];
    
   // CGSize windowSize = pListView.frame.size;
    if (cell == nil) {
		
		NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MemberViewCell" owner:nil options:nil];
		cell = [arr objectAtIndex:0];
	}
	[cell setAccessoryType:UITableViewCellAccessoryNone];
    
    
    cell.pBackImageView.image = [[UIImage imageNamed:@"box.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];

    cell.pBackImageView.frame = CGRectMake(
                                    cell.pBackImageView.frame.origin.x,
                                    cell.pBackImageView.frame.origin.y,
                                    MAX(dataSize.width, [self getBoxSize:cell.pNameView.text].width + WIDTH_SPACE ),
                                    30);
    
 
    
   cell.pNameView.text = rowData.pUserName;      //  대화명
   cell.pContextView.text = rowData.pContext;    // 대화내용
   // cell.pImageView.image = [UIImage imageNamed:@""];
  
	return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [pNetWorkController SendReqvCommand:indexPath.row];
}


- (void)ChatViewShow
{
    // 일대일 대화창 화면을 전환합니다.
    [self presentViewController:self.pCharViewController animated:YES completion:nil];

}

-(void) NetWorkInit
{
    pNetWorkController = [[NetWorkController alloc] init];
    
    if(pCharViewController == nil)    // CharViewController.xib 파일을 로드하여 객체를 생성합니다.
        pCharViewController = [[CharViewController alloc] initWithNibName:@"CharViewController" bundle:nil];
   
 
    pCharViewController.pNetWorkController = pNetWorkController;
    pNetWorkController.pCharViewController = pCharViewController;
    pNetWorkController.pMemberListViewController = self;
  
}

@end
