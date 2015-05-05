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
    
    /*
     Construct the session used for the authentication and form submission.
     */
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    
    /*
     Setup Basic authentication
     */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://epro-url.imedidata.net/api/Username/authenticate"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSData *authData = [@"Username:Password" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    
    /*
     Authenticate the user with the Patient Cloud Gateway.
     */
    NSError *jError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:@{@"password" : @{@"primary_password" : @"Password"}}
                                                       options:0
                                                         error:&jError];
    [request setHTTPBody:postData];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            NSLog(@"error %@", [error localizedDescription]);
        } else {
            NSLog(@"success!");
        }
    }] resume];
    
    
    /*
     Extract data from the ORKTaskResult and serialize it in the format expected by the Patient Cloud Gateway.
     */
    NSMutableDictionary *params = [self odmParameters];
    [params setObject:[taskViewController.result mork_fieldDataFromResults] forKey:@"field_data"];
    NSData *odmData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObject:params forKey:@"form_data"]
                                                      options:0
                                                        error:nil];
    
    
    /* 
     Post the results to the Patient Cloud Gateway.
     */
    [request setURL:[NSURL URLWithString:@"https://epro-url.imedidata.net/api/odm"]];
    [request setHTTPBody:odmData];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            NSLog(@"error %@", [error localizedDescription]);
        } else {
            NSLog(@"success!");
        }
    }] resume];
    
    
    /*
     Show the user an alert thanking them for taking the form.
     */
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Form Completed"
                                                    message:@"Thank you for completing the form!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}


-(NSData *) authenticationJSON {
    NSDictionary *json = @{@"password" : @{@"primary_password" : @"Password"}};
    NSError *jError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&jError];
    return postData;
}


-(NSMutableDictionary *) odmParameters {
    NSDictionary *params = @{
                             @"subject_name": @"SB01",
                             @"study_uuid": @"e018fcb9-e06a-4ecb-8496-7af5af03b0b2",
                             @"signature_date_time_entered": @"2014-12-10T17:03:24",
                             @"folder_oid": @"SCREEN",
                             @"form_oid": @"MORK_FRM",
                             @"site_oid": @"site1",
                             @"version": @"1.0",
                             @"device_id": @"3FC94B89-920C-412A-BB9D-BFA9DF40F1B1",
                             @"rave_url": @"https://my-rave-url.mdsol.com",
                             @"study_name": @"MyStudyName",
                             @"subject_uuid": @"ba86d135-0f64-42a9-a45c-89087eb44fbe",
                             @"record_oid": @"MORK_FRM_LOG_LINE",
                             @"log_line": @1
                             };
    
    return [NSMutableDictionary dictionaryWithDictionary:params];
}


-(NSMutableArray *) createSteps {
    NSMutableArray *steps = [NSMutableArray new];
    
    
    {
        ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:@"intro"];
        step.title = @"Welcome to ResearchKit";
        [steps addObject:step];
    }
    
    /*
     Corresponding control types:
        Rave Architect: Drop Down List, Radio Button
        Patient Cloud: Patient Cloud: Dictionary
     */
    {
        NSArray *choices = @[[ORKTextChoice choiceWithText:@"Male" detailText:nil value:@"M"],
                             [ORKTextChoice choiceWithText:@"Female" detailText:nil value:@"F"]];
        ORKTextChoiceAnswerFormat *textFormat = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:ORKChoiceAnswerStyleSingleChoice textChoices:choices];
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:@"GENDER" title:@"Gender" answer:textFormat];
        [steps addObject:step];
    }
    
    /*
     Corresponding control types: 
        Rave Architect: Date Time
        Patient Cloud: Date Time
     */
    {
        ORKDateAnswerFormat *dateFormat = [ORKDateAnswerFormat dateAnswerFormat];
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier: @"DOB" title: @"When were you born?" answer: dateFormat];
        [steps addObject:step];
    }
    
    /*
     Corresponding control types: 
        Rave Architect: Drop Down List, Radio Button
        Patient Cloud: Dictionary
     */
    {
        NSArray *choices = @[[ORKTextChoice choiceWithText:@"Never" detailText:nil value:@1],
                             [ORKTextChoice choiceWithText:@"Rarely" detailText:nil value:@2],
                             [ORKTextChoice choiceWithText:@"Somewhat" detailText:nil value:@3],
                             [ORKTextChoice choiceWithText:@"Often" detailText:nil value:@4]];
        ORKTextChoiceAnswerFormat *textFormat = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:ORKChoiceAnswerStyleSingleChoice textChoices:choices];
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:@"EXERCISE" title:@"How often do you exercise?" answer:textFormat];
        [steps addObject:step];
    }
    
    /*
     Corresponding control types:
        Rave Architect: Text
        Patient Cloud: VAS, NRS
     */
    {
        ORKScaleAnswerFormat *scaleFormat = [[ORKScaleAnswerFormat alloc] initWithMaximumValue:10 minimumValue:1 step:1 defaultValue:5];
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:@"PAIN_LEVEL" title:@"How much pain do you feel in your arm?" answer:scaleFormat];
        [steps addObject:step];
    }
    
    return steps;
}

@end
