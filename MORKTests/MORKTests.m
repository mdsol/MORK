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
    
    XCTAssert([[result rawResult] isEqualToString: [today description]]);
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
    
    NSDictionary *expectedDictionary = @{
                                         @"data_value" : @"10",
                                         @"item_oid" : @"scale",
                                         @"date_time_entered" : [now description]
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
    
    NSArray *expectedArray = @[
                               @{
                                   @"data_value" : @"YES",
                                   @"item_oid" : @"choice",
                                   @"date_time_entered" : [now description]
                                   },
                               @{
                                   @"data_value" : @"10",
                                   @"item_oid" : @"scale",
                                   @"date_time_entered" : [now description]
                                   }
                               ];
    
    XCTAssert([[stepResult fieldDataFromResults] isEqualToArray:expectedArray]);
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
