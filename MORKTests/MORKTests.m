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

- (void)setUp {
    [super setUp];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    today = [NSDate date];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDateTimeQuestionResultReturnsCorrectRawResult {
    ORKDateQuestionResult *result = [[ORKDateQuestionResult alloc] init];
    
    result.dateAnswer = today;
    
    NSString* expectedString = [dateFormatter stringFromDate:today];
    
    XCTAssert([[result mork_rawResult] isEqualToString: expectedString]);
}

- (void)testScaleQuestionResultReturnsCorrectRawResult {
    ORKScaleQuestionResult *result = [[ORKScaleQuestionResult alloc] init];
    result.scaleAnswer = @10;
    
    XCTAssert([[result mork_rawResult] isEqualToString:@"10"]);
}

- (void)testChoiceQuestionResultReturnsCorrectRawResult {
    ORKChoiceQuestionResult *result = [[ORKChoiceQuestionResult alloc] init];
    result.choiceAnswers = @[@"YES"];
    
    XCTAssert([[result mork_rawResult] isEqualToString:@"YES"]);
    
}

- (void)testFieldDataReturnsProperDictionary {
    ORKScaleQuestionResult *result = [[ORKScaleQuestionResult alloc] initWithIdentifier:@"scale"];
    
    result.scaleAnswer = @10;
    result.endDate = today;
    
    NSDictionary *expectedDictionary = @{
                                         @"data_value" : @"10",
                                         @"item_oid" : @"scale",
                                         @"date_time_entered" : [dateFormatter stringFromDate:today]
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
                                   @"date_time_entered" : [dateFormatter stringFromDate:today]
                                   },
                               @{
                                   @"data_value" : @"10",
                                   @"item_oid" : @"scale",
                                   @"date_time_entered" : [dateFormatter stringFromDate:today]
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
                                   @"date_time_entered" : [dateFormatter stringFromDate:today]
                                   },
                               @{
                                   @"data_value" : @"10",
                                   @"item_oid" : @"scale",
                                   @"date_time_entered" : [dateFormatter stringFromDate:today]
                                   }
                               ];
    
    XCTAssert([[taskResult mork_fieldDataFromResults] isEqualToArray:expectedArray]);
}

@end
