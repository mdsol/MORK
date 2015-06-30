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
@property (strong, nonatomic) NSDate *today;
@property (copy, nonatomic) NSString *todayString;
@end

@implementation MORKTests

- (void)setUp {
    [super setUp];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'hh:mm:ss";
    self.today = [NSDate date];
    self.todayString = [dateFormatter stringFromDate:self.today];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testChoiceQuestionResultReturnsProperDictionary {
    ORKChoiceQuestionResult *result = [[ORKChoiceQuestionResult alloc] initWithIdentifier:@"choice"];
    result.choiceAnswers = @[@"YES"];
    result.endDate = self.today;

    NSDictionary *expectedDictionary = @{@"data_value"          : @"YES",
                                         @"item_oid"            : @"choice",
                                         @"date_time_entered"   : self.todayString};

    XCTAssert([[result mork_getFieldDataDictionary] isEqualToDictionary:expectedDictionary]);
}

- (void)testDateTimeQuestionResultReturnsProperDictionary {
    ORKDateQuestionResult *result = [[ORKDateQuestionResult alloc] initWithIdentifier:@"date"];
    result.dateAnswer = self.today;
    result.endDate = self.today;

    NSDictionary *expectedDictionary = @{@"data_value"          : self.todayString,
                                         @"item_oid"            : @"date",
                                         @"date_time_entered"   : self.todayString};

    XCTAssert([[result mork_getFieldDataDictionary] isEqualToDictionary:expectedDictionary]);
}


- (void)testScaleQuestionResultReturnsProperDictionary {
    ORKScaleQuestionResult *result = [[ORKScaleQuestionResult alloc] initWithIdentifier:@"scale"];

    result.scaleAnswer = @10;
    result.endDate = self.today;

    NSDictionary *expectedDictionary = @{@"data_value"          : @"10",
                                         @"item_oid"            : @"scale",
                                         @"date_time_entered"   : self.todayString};

    XCTAssert([[result mork_getFieldDataDictionary] isEqualToDictionary:expectedDictionary]);
}


- (void)testNestedTaskResultsReturnsFieldDataArray {

    ORKChoiceQuestionResult *qResult = [[ORKChoiceQuestionResult alloc] initWithIdentifier:@"choice"];
    qResult.choiceAnswers = @[@"YES"];
    qResult.endDate = self.today;

    ORKScaleQuestionResult *sResult = [[ORKScaleQuestionResult alloc] initWithIdentifier:@"scale"];
    sResult.scaleAnswer = @10;
    qResult.endDate = self.today;

    ORKStepResult *stepResult = [[ORKStepResult alloc] initWithStepIdentifier:@"steps" results:@[qResult, sResult]];

    ORKTaskResult *taskResult = [[ORKTaskResult alloc] initWithIdentifier:@"task"];
    taskResult.results = @[stepResult];

    NSArray *expectedArray = @[@{@"data_value"          : @"YES",
                                 @"item_oid"            : @"choice",
                                 @"date_time_entered"   : self.todayString},
                               @{@"data_value"          : @"10",
                                 @"item_oid"            : @"scale",
                                 @"date_time_entered"   : self.todayString}];

    XCTAssert([[taskResult mork_getFieldDataFromResults] isEqualToArray:expectedArray]);
}

@end
