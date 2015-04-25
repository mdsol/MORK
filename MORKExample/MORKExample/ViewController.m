//
//  ViewController.m
//  MORKExample
//
//  Created by Nolan Carroll on 4/23/15.
//  Copyright (c) 2015 Medidata Solutions. All rights reserved.
//

#import "ViewController.h"
#import <ResearchKit/ResearchKit.h>
#import <MORK/MORK.h>
#import <MORK/ORKCollectionResult+MORK.h>

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ORKOrderedTask *task  = [[ORKOrderedTask alloc] initWithIdentifier:@"task" steps:[self createSteps]];
    self.taskViewController = [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
    
    self.taskViewController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentViewController:self.taskViewController animated:YES completion:nil];
}


- (void)taskViewController:(ORKTaskViewController *)taskViewController
       didFinishWithReason:(ORKTaskViewControllerFinishReason)reason
                     error:(NSError *)error {
    
    
    ORKTaskResult *taskResult = taskViewController.result;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Form Completed"
                                                    message:@"Thank you for completing the form!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}


-(NSMutableArray *) createSteps {
    NSMutableArray *steps = [NSMutableArray new];
    
    
    {
        ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:@"intro"];
        step.title = @"Welcome to ResearchKit";
        [steps addObject:step];
    }
    
    
    {
        NSArray *choices = @[[ORKTextChoice choiceWithText:@"Male" detailText:nil value:@"M"],
                             [ORKTextChoice choiceWithText:@"Female" detailText:nil value:@"F"]];
        ORKTextChoiceAnswerFormat *textFormat = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:ORKChoiceAnswerStyleSingleChoice textChoices:choices];
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:@"GENDER" title:@"Gender" answer:textFormat];
        [steps addObject:step];
    }
    
    
    {
        ORKDateAnswerFormat *dateFormat = [ORKDateAnswerFormat dateAnswerFormat];
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier: @"DOB" title: @"When were you born?" answer: dateFormat];
        [steps addObject:step];
    }
    
    
    {
        NSArray *choices = @[[ORKTextChoice choiceWithText:@"Never" detailText:nil value:@"Never"],
                             [ORKTextChoice choiceWithText:@"Rarely" detailText:nil value:@"Rarely"],
                             [ORKTextChoice choiceWithText:@"Somewhat" detailText:nil value:@"Somewhat"],
                             [ORKTextChoice choiceWithText:@"Often" detailText:nil value:@"Often"]];
        ORKTextChoiceAnswerFormat *textFormat = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:ORKChoiceAnswerStyleSingleChoice textChoices:choices];
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:@"EXERCISE" title:@"How often do you exercise?" answer:textFormat];
        [steps addObject:step];
    }
    
    
    {
        ORKScaleAnswerFormat *scaleFormat = [[ORKScaleAnswerFormat alloc] initWithMaximumValue:10 minimumValue:1 step:1 defaultValue:5];
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:@"PAIN_LEVEL" title:@"How much pain do you feel in your arm?" answer:scaleFormat];
        [steps addObject:step];
    }
    
    
    return steps;
}

@end
