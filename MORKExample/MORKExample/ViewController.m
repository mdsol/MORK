//
//  ViewController.m
//  MORKExample
//
//  Created by Nolan Carroll on 4/23/15.
//  Copyright (c) 2015 Medidata Solutions. All rights reserved.
//

#import "ViewController.h"
#import <ResearchKit/ResearchKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    NSMutableArray *steps = [self createSteps];
    ORKOrderedTask *task  = [[ORKOrderedTask alloc] initWithIdentifier:@"task" steps:steps];
    ORKTaskViewController *taskViewController = [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
    
    taskViewController.delegate = self;
    [self presentViewController:taskViewController animated:YES completion:nil];
}


- (void)taskViewController:(ORKTaskViewController *)taskViewController
       didFinishWithReason:(ORKTaskViewControllerFinishReason)reason
                     error:(NSError *)error {
    

    [self dismissViewControllerAnimated:YES completion:nil];
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
