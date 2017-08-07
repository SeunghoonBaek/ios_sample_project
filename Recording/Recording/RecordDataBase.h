//
//  RecordDataBase.h
//  Recording
//
//  Created by baek on 2017. 8. 8..
//  Copyright © 2017년 baek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
@interface RecordDataBase : NSObject
-(void) DataBaseConnection:(sqlite3 **)tempDataBase;
-(void) getRecordList;
-(void) insertRecordData:(NSString *)pSEQ RecordingTM:(NSInteger)pRecordingTM RecordFileNM:(NSString *) pRecordFileNM;
-(void) deleteRecordData:(NSString *)pSEQ;
@property (strong, nonatomic) NSMutableArray* memoListArray;
@end
