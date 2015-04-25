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

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDateTimeQuestionResultReturnsCorrectRawResult {
    ORKDateQuestionResult *result = [[ORKDateQuestionResult alloc] init];
    
    NSDate *today = [NSDate date];
    result.dateAnswer = today;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString* expectedString = [formatter stringFromDate:today];
    
    XCTAssert([[result rawResult] isEqualToString: expectedString]);
}

- (void)testScaleQuestionResultReturnsCorrectRawResult {
    ORKScaleQuestionResult *result = [[ORKScaleQuestionResult alloc] init];
    result.scaleAnswer = @10;
    
    XCTAssert([[result rawResult] isEqualToString:@"10"]);
}

- (void)testChoiceQuestionResultReturnsCorrectRawResult {
    ORKChoiceQuestionResult *result = [[ORKChoiceQuestionResult alloc] init];
    result.choiceAnswers = @[@"YES"];
    
    XCTAssert([[result rawResult] isEqualToString:@"YES"]);
    
}

- (void)testFieldDataReturnsProperDictionary {
    ORKScaleQuestionResult *result = [[ORKScaleQuestionResult alloc] initWithIdentifier:@"scale"];
    NSDate *now = [NSDate date];
    
    result.scaleAnswer = @10;
    result.endDate = now;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    NSDictionary *expectedDictionary = @{
                                         @"data_value" : @"10",
                                         @"item_oid" : @"scale",
                                         @"date_time_entered" : [formatter stringFromDate:now]
                                         };
    
    XCTAssert([[result fieldDataDictionary] isEqualToDictionary:expectedDictionary]);
}

- (void)testCollectionResultReturnsFieldDataArray {
    NSDate *now = [NSDate date];
    
    ORKChoiceQuestionResult *qResult = [[ORKChoiceQuestionResult alloc] initWithIdentifier:@"choice"];
    qResult.choiceAnswers = @[@"YES"];
    qResult.endDate = now;
    
    ORKScaleQuestionResult *sResult = [[ORKScaleQuestionResult alloc] initWithIdentifier:@"scale"];
    sResult.scaleAnswer = @10;
    qResult.endDate = now;
    
    ORKStepResult *stepResult = [[ORKStepResult alloc] initWithStepIdentifier:@"steps" results:@[qResult, sResult]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    NSArray *expectedArray = @[
                               @{
                                   @"data_value" : @"YES",
                                   @"item_oid" : @"choice",
                                   @"date_time_entered" : [formatter stringFromDate:now]
                                   },
                               @{
                                   @"data_value" : @"10",
                                   @"item_oid" : @"scale",
                                   @"date_time_entered" : [formatter stringFromDate:now]
                                   }
                               ];
    
    XCTAssert([[stepResult fieldDataFromResults] isEqualToArray:expectedArray]);
}

- (void)testNestedTaskResultsReturnsFieldDataArray {
    NSDate *now = [NSDate date];
}

@end
