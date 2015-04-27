//
//  MORKTests.m
//  MORKTests
//
//  Created by Nolan Carroll on 4/23/15.
//  Copyright (c) 2015 Medidata Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <ResearchKit/ResearchKit.h>
#import <MORK/MORK.h>

@interface MORKTests : XCTestCase

@end

@implementation MORKTests

NSDateFormatter *dateFormatter;
NSDate *today;
NSString *todayString;


- (void)setUp {
    [super setUp];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    today = [NSDate date];
    todayString = [dateFormatter stringFromDate:today];
}


- (void)tearDown {
    [super tearDown];
}


- (void)testChoiceQuestionResultReturnsProperDictionary {
    ORKChoiceQuestionResult *result = [[ORKChoiceQuestionResult alloc] initWithIdentifier:@"choice"];
    result.choiceAnswers = @[@"YES"];
    result.endDate = today;

    NSDictionary *expectedDictionary = @{
                                         @"data_value" : @"YES",
                                         @"item_oid" : @"choice",
                                         @"date_time_entered" : todayString
                                         };
    
    XCTAssert([[result mork_fieldDataDictionary] isEqualToDictionary:expectedDictionary]);
}


- (void)testDateTimeQuestionResultReturnsProperDictionary {
    ORKDateQuestionResult *result = [[ORKDateQuestionResult alloc] initWithIdentifier:@"date"];
    result.dateAnswer = today;
    result.endDate = today;
    
    NSDictionary *expectedDictionary = @{
                                         @"data_value" : todayString,
                                         @"item_oid" : @"date",
                                         @"date_time_entered" : todayString
                                         };
    
    XCTAssert([[result mork_fieldDataDictionary] isEqualToDictionary:expectedDictionary]);
}


- (void)testScaleQuestionResultReturnsProperDictionary {
    ORKScaleQuestionResult *result = [[ORKScaleQuestionResult alloc] initWithIdentifier:@"scale"];
    
    result.scaleAnswer = @10;
    result.endDate = today;
    
    NSDictionary *expectedDictionary = @{
                                         @"data_value" : @"10",
                                         @"item_oid" : @"scale",
                                         @"date_time_entered" : todayString
                                         };
    
    XCTAssert([[result mork_fieldDataDictionary] isEqualToDictionary:expectedDictionary]);
}


- (void)testCollectionResultReturnsFieldDataArray {
    ORKChoiceQuestionResult *qResult = [[ORKChoiceQuestionResult alloc] initWithIdentifier:@"choice"];
    qResult.choiceAnswers = @[@"YES"];
    qResult.endDate = today;
    
    ORKScaleQuestionResult *sResult = [[ORKScaleQuestionResult alloc] initWithIdentifier:@"scale"];
    sResult.scaleAnswer = @10;
    qResult.endDate = today;
    
    ORKStepResult *stepResult = [[ORKStepResult alloc] initWithStepIdentifier:@"steps" results:@[qResult, sResult]];
    
    NSArray *expectedArray = @[
                               @{
                                   @"data_value" : @"YES",
                                   @"item_oid" : @"choice",
                                   @"date_time_entered" : todayString
                                   },
                               @{
                                   @"data_value" : @"10",
                                   @"item_oid" : @"scale",
                                   @"date_time_entered" : todayString
                                   }
                               ];
    
    XCTAssert([[stepResult mork_fieldDataFromResults] isEqualToArray:expectedArray]);
}


- (void)testNestedTaskResultsReturnsFieldDataArray {
    
    ORKChoiceQuestionResult *qResult = [[ORKChoiceQuestionResult alloc] initWithIdentifier:@"choice"];
    qResult.choiceAnswers = @[@"YES"];
    qResult.endDate = today;
    
    ORKScaleQuestionResult *sResult = [[ORKScaleQuestionResult alloc] initWithIdentifier:@"scale"];
    sResult.scaleAnswer = @10;
    qResult.endDate = today;
    
    ORKStepResult *stepResult = [[ORKStepResult alloc] initWithStepIdentifier:@"steps" results:@[qResult, sResult]];

    ORKTaskResult *taskResult = [[ORKTaskResult alloc] initWithIdentifier:@"task"];
    taskResult.results = @[stepResult];
    
    NSArray *expectedArray = @[
                               @{
                                   @"data_value" : @"YES",
                                   @"item_oid" : @"choice",
                                   @"date_time_entered" : todayString
                                   },
                               @{
                                   @"data_value" : @"10",
                                   @"item_oid" : @"scale",
                                   @"date_time_entered" : todayString
                                   }
                               ];
    
    XCTAssert([[taskResult mork_fieldDataFromResults] isEqualToArray:expectedArray]);
}

@end
