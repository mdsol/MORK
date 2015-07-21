//
//  ViewController.swift
//  MORKExample
//
//  Created by Kerry Knight on 6/11/15.
//  Copyright (c) 2015 Medidata Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ORKTaskViewControllerDelegate {

    private var taskViewController: ORKTaskViewController!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // create our steps
        let steps = self.createSteps() as! [ORKStep];

        // add to our task
        let task: ORKOrderedTask = ORKOrderedTask(identifier: "task", steps: steps)

        // set up our task controller with our new task
        self.taskViewController = ORKTaskViewController(task: task, taskRunUUID: nil)
        self.taskViewController?.delegate = self;
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.presentViewController(self.taskViewController, animated: true, completion: nil)
    }

    // MARK: - Private Methods
    func createSteps() -> NSArray {

        // we'll add all our individual step objects to our mutable steps array
        var steps: [ORKStep] = [];

        var step: ORKStep = ORKInstructionStep(identifier: "intro")
        step.title = "Welcome to ResearchKit"
        steps += [step]

        /*
        Corresponding control types:
        Rave Architect: Drop Down List, Radio Button
        Patient Cloud: Patient Cloud: Dictionary
        */
        var choices: [ORKTextChoice] = [ORKTextChoice(text: "Male", value: "M"),
                                        ORKTextChoice(text: "Female", value: "F")]
        var textFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: choices)
        step = ORKQuestionStep(identifier: "GENDER", title: "Gender", answer: textFormat)
        steps += [step]

        /*
        Corresponding control types:
        Rave Architect: Date Time
        Patient Cloud: Date Time
        */
        let dateFormat: ORKDateAnswerFormat = ORKDateAnswerFormat.dateAnswerFormat()
        step = ORKQuestionStep(identifier: "DOB", title: "When were you born?", answer: dateFormat)
        steps += [step]

        /*
        Corresponding control types:
        Rave Architect: Drop Down List, Radio Button
        Patient Cloud: Dictionary
        */
        choices = [ORKTextChoice(text: "Never", value: 1),
                   ORKTextChoice(text: "Rarely", value: 2),
                   ORKTextChoice(text: "Somewhat", value: 3),
                   ORKTextChoice(text: "Often", value: 4)]
        textFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: choices)
        step = ORKQuestionStep(identifier: "EXERCISE", title: "How often do you excercise?", answer: textFormat)
        steps += [step]

        /*
        Corresponding control types:
        Rave Architect: Text
        Patient Cloud: VAS, NRS
        */
        let scaleFormat: ORKScaleAnswerFormat = ORKScaleAnswerFormat(maximumValue: 10, minimumValue: 1, defaultValue: 5, step: 1)
        step = ORKQuestionStep(identifier: "PAIN LEVEL", title: "How much pain do you feel in your arm?", answer: scaleFormat)
        steps += [step]

        return steps
    }

    func odmParameters() -> NSMutableDictionary {
        return ["subject_name"                : "SB01",
                "study_uuid"                  : "e018fcb9-e06a-4ecb-8496-7af5af03b0b2",
                "signature_date_time_entered" : "2014-12-10T17:03:24",
                "folder_oid"                  : "SCREEN",
                "form_oid"                    : "MORK_FRM",
                "site_oid"                    : "site1",
                "version"                     : "1.0",
                "device_id"                   : "3FC94B89-920C-412A-BB9D-BFA9DF40F1B1",
                "rave_url"                    : "https://my-rave-url.mdsol.com",
                "study_name"                  : "MyStudyName",
                "subject_uuid"                : "ba86d135-0f64-42a9-a45c-89087eb44fbe",
                "record_oid"                  : "MORK_FRM_LOG_LINE",
                "log_line"                    : 1]
    }
}

// MARK: - ORKTaskViewControllerDelegate
extension ViewController : ORKTaskViewControllerDelegate {

    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {

        /*
        Construct the session used for the authentication and form submission.
        */
        let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session: NSURLSession = NSURLSession(configuration: configuration)

        /*
        Setup Basic authentication and build our request
        */
        var urlString: String = "https://epro-url.imedidata.net/api/Username/authenticate"
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!,
                                                               cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy,
                                                               timeoutInterval: 60)
        let authData: NSData = ("Username:Password" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        let authValue: String = "Basic " + authData.base64EncodedStringWithOptions(nil)

        // add our request headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authValue, forHTTPHeaderField: "Authorization")
        request.HTTPMethod = "POST"

        /*
        Authenticate the user with the Patient Cloud Gateway.
        */
        let json: NSDictionary = ["password":["primary_password":"Password"]];
        var error: NSError?
        var postData: NSData = NSJSONSerialization.dataWithJSONObject(json, options: nil, error: &error)!

        if error != nil {
            println("Error creating post data for json \(json)")
            return
        }

        // add the body of our request
        request.HTTPBody = postData

        // kick off our authentication request to ensure we have a real Patient Cloud user account
        session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            // authentication request returned
            if error != nil {
                // failed authentication; do we have an account?
                println("error \(error.localizedDescription)")
            } else {
                // we successfully authenticated with Patient Cloud
                println("Success!")
            }
        }).resume()

        /*
        Extract data from the ORKTaskResult and serialize it in the format expected by the Patient Cloud Gateway.
        */
        var params = self.odmParameters()
        params["field_data"] = taskViewController.result.mork_getFieldDataFromResults()

        postData = NSJSONSerialization.dataWithJSONObject(["form_data": params], options: nil, error: &error)!

        if error != nil {
            println("Error creating post data for json \(params)")
            return
        }

        /*
        Post the results to the Patient Cloud Gateway.
        */
        urlString = "https://epro-url.imedidata.net/api/odm"
        request.URL = NSURL(string: urlString)!
        request.HTTPBody = postData

        session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            // upload request returned
            if error != nil {
                // upload failed
                println("error \(error.localizedDescription)")
            } else {
                // we successfully uploaded to Patient Cloud
                println("Success!")
            }
        }).resume()

        /*
        Show the user an alert thanking them for taking the form.
        */
        var alert = UIAlertController(title: "Form Completed",
                                      message: "Thank you for completing the form!",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertActionStyle.Default,
                                      handler: nil))
        self.taskViewController.presentViewController(alert, animated: true, completion: nil)
    }
}

