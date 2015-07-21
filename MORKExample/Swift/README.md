# MORKExample

MORKExample is an example project that uses the MORK extensions to persist data to Rave.

To run the example project, navigate to the MORKExample folder and run `pod install`. Open MORKExample.xcworkspace and run the project.

The results are collected and serialized in the `taskViewController(didFinishWithReason: error:)` method of the ViewController. Once collected, these results are sent to the Patient Cloud Gateway, where they are persisted as log lines in Rave. The `odmParameters` method in the ViewController contains hardcoded data necessary for this persistence. In a real-world app, this data could be generated dynamically before being sent to the Gateway.
