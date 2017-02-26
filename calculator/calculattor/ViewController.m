//
//  ViewController.m
//  calculattor
//
//  Created by baek-pc on 2017. 2. 26..
//  Copyright © 2017년 baek-pc. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize curStatusCode;
@synthesize curValue;
@synthesize totalCurValue;
@synthesize displayLabel;

- (void)viewDidLoad {
    [self ClearCalculation];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void) DisplayInputValue : (NSString*) displayText {
    NSString* CommaText;
    CommaText = [self ConvertComma:displayText];
    
    [displayLabel setText:CommaText];
}

- (void) DisplayCalculationValue{
    NSString* displayText;
    displayText = [NSString stringWithFormat:@"%g", totalCurValue];
    
    [self DisplayInputValue:displayText];
    curInputValue = @"";
}

-(void) ClearCalculation{
    curInputValue = @"";
    curValue = 0;
    totalCurValue = 0;
    
    [self DisplayInputValue:curInputValue];
    curStatusCode = STATUS_DEFAULT;
}

-(NSString *) ConvertComma:(NSString *) data
{
    if(data == nil){
        return nil;
    }
    if([data length] <= 3){
        return data;
    }
    
    NSString* integerString = nil;
    NSString* floatString = nil;
    NSString* minusString = nil;
    
    // Find dicimal position
    NSRange pointRange = [data rangeOfString:@"."];
    if(pointRange.location == NSNotFound){
        integerString = data;
    }
    
    else{
        
        // Find dicimal position under integers.
        NSRange r;
        r.location = pointRange.location;
        r.length = [data length] - pointRange.location;
        
        floatString = [data substringWithRange:r];
        
        // Find integer position.
        r.location = 0;
        r.length = pointRange.location;
        integerString = [data substringWithRange:r];
    }
    
    // Find minus position
    NSRange minusRange = [integerString rangeOfString:@"-"];
    if(minusRange.location != NSNotFound){
        minusString = @"-";
        integerString = [integerString stringByReplacingOccurrencesOfString:@"-" withString:@"" ];
    }
    
    // Insert comma charactor into numbers.
    NSMutableString* integerStringCommaInserted = [[NSMutableString alloc] init];
    NSUInteger integerStringLength = [integerString length];
    int idx;
    
    while(idx < integerStringLength){
        [integerStringCommaInserted appendFormat:@"%C", [integerString characterAtIndex:idx]];
        
        if((integerStringLength - (idx + 1)) % 3 == 0 && integerStringLength != (idx + 1)){
            [integerStringCommaInserted appendString:@","];
        }
        
        idx++;
    }
    
    // Set return string.
    NSMutableString* returnString = [[NSMutableString alloc] init];
    if(minusString != nil){
        [returnString appendString:minusString];
    }
    if(integerStringCommaInserted != nil){
        [returnString appendString:integerStringCommaInserted];
    }
    if(floatString != nil){
        [returnString appendString:floatString];
    }
    
    return returnString;
}

-(IBAction) digitPressed:(UIButton *)sender{
    NSString* numPoint = [[sender titleLabel] text];
    curInputValue = [curInputValue stringByAppendingFormat:numPoint];
    [self DisplayInputValue:curInputValue];
}


-(IBAction) operationPressed:(UIButton *)sender{
    NSString* operationText = [[sender titleLabel] text];
    
    if([@"+" isEqualToString:operationText]){
        [self Calculation:curStatusCode CurStatusCode:STATUS_PLUS];
    }
    
    else if([@"-" isEqualToString:operationText]){
        [self Calculation:curStatusCode CurStatusCode:STATUS_MINUS];
    }
    
    else if([@"*" isEqualToString:operationText]){
        [self Calculation:curStatusCode CurStatusCode:STATUS_MULTIPLY];
    }
    
    else if([@"/" isEqualToString:operationText]){
        [self Calculation:curStatusCode CurStatusCode:STATUS_DIVISION];
    }
    
    else if([@"C" isEqualToString:operationText]){
        [self ClearCalculation];
    }
    else if([@"=" isEqualToString:operationText]){
        [self Calculation:curStatusCode CurStatusCode:STATUS_RETURN];
    }
}


-(void) Calculation:(kStatusCode)StatusCode CurStatusCode:(kStatusCode)cStatusCode{
    switch(StatusCode){
        case STATUS_DEFAULT:
            [self DefaultCalculation];
            break;
            
        case STATUS_DIVISION :
            [self DivisionCalculation];
            break;
            
        case STATUS_MULTIPLY :
            [self MultiplyCalculation];
            break;
            
        case STATUS_MINUS :
            [self MinusCalculation];
            break;
            
        case STATUS_PLUS :
            [self PlusCalculation];
            break;
            
        case STATUS_RETURN :
            break;
    }
    
    curStatusCode = cStatusCode;
}

-(void) DefaultCalculation{
    curValue = [curInputValue doubleValue];
    totalCurValue = curValue;
    
    [self DisplayCalculationValue];
}

-(void) PlusCalculation{
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue + curValue;
    
    [self DisplayCalculationValue];
}

-(void) MinusCalculation{
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue - curValue;
    
    [self DisplayCalculationValue];
}

-(void) MultiplyCalculation{
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue * curValue;
    
    [self DisplayCalculationValue];
}

-(void) DivisionCalculation{
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue / curValue;
    
    [self DisplayCalculationValue];
}
@end
