# MORK

MORK is an extension of [Apple ResearchKit](https://github.com/ResearchKit/ResearchKit) that facilitates easy serialization of ResearchKit data into the form required by the Patient Cloud Gateway.

## Methods

MORK adds two methods to ResearchKit objects:

#### `[ORKResult mork_fieldDataDictionary]`

Returns an `NSDictionary *` containing the step's result, in the form:

```
@{
   @"data_value" : @"<value>",
   @"item_oid" : @"<step identifier>",
   @"date_time_entered" : @"<date entered>"  
}
```

#### `[ORKCollectionResult mork_fieldDataFromResults]`

Returns an `NSArray *` containing the result of `mork_fieldDataDictionary` for each `ORKStepResult` in the `ORKCollectionResult`:

```
@[
  @{
     @"data_value" : @"<value>",
     @"item_oid" : @"<step identifier>",
     @"date_time_entered" : @"<date entered>"  
  },
  @{
     @"data_value" : @"<value>",
     @"item_oid" : @"<step identifier>",
     @"date_time_entered" : @"<date entered>"  
  },
  ...
]
```

The `mork_fieldDataFromResults` method can be converted to JSON and sent to the Patient Cloud Gateway to create an entry in Rave.

## Example Project

To run the example project, navigate to the MORKExample folder and run `pod install`. Open MORKExample.xcworkspace and run the project.

The results are collected and serialized in the `taskViewController:didFinishWithReason:error` method of the ViewController.

# Patient Cloud / ResearchKit Integration

## Common Fields
Most Rave fields can be represented by an `ORKQuestionStep`. Special fields such as consent forms and form submission can be represented by
other subclasses of `ORKStep` (`ORKVisualConsentStep`, `ORKCompletionStep`).

If multiple questions should be shown on a single, scrollable page, an `ORKFormStep` can be used to encapsulate multiple `ORKSteps`

Fields shared by all Rave Architect Fields:

| Rave Architect Field | ResearchKit Field                                    |
| -------------------  | ----------------                                     |
| FieldOID             | `ORKStep.identifer`                                  |
| Header Text          | `ORKStep.title`                                      |
| Field Label (?)      | `ORKStep.text`                                       |
| VariableFormat       | See [Formatting](#formatting-and-validation) Section |



## Control Types

Many Rave and Patient Cloud Fields can be supported through configuration of existing ResearchKit Objects. For some Fields additional customization would be required (e.g. subclassing ORKQuestion).

| Rave Control        | ResearchKit Control                                                                                                                                                                                                                                                                                       |
| --------------      | ---------                                                                                                                                                                                                                                                                                                 |
| Text                | [ORKTextAnswerFormat](http://researchkit.github.io/docs/Classes/ORKTextAnswerFormat.html), [ORKNumericAnswerFormat](http://researchkit.github.io/docs/Classes/ORKNumericAnswerFormat.html)                                                                                                                |
| Date Time           | [ORKDateAnswerFormat](http://researchkit.github.io/docs/Classes/ORKDateAnswerFormat.html), [ORKTimeIntervalAnswerFormat](http://researchkit.github.io/docs/Classes/ORKTimeIntervalAnswerFormat.html), [ORKTimeOfDayAnswerFormat](http://researchkit.github.io/docs/Classes/ORKTimeOfDayAnswerFormat.html) |
| Drop Down List      | [ORKTextChoiceAnswerFormat](http://researchkit.github.io/docs/Classes/ORKTextChoiceAnswerFormat.html)                                                                                                                                                                                                     |
| Radio Button        | [ORKTextChoiceAnswerFormat](http://researchkit.github.io/docs/Classes/ORKTextChoiceAnswerFormat.html)                                                                                                                                                                                                     |
| Signature           | [ORKConsentReviewStep](http://researchkit.github.io/docs/Classes/ORKConsentReviewStep.html) + [ORKConsentSignature](http://researchkit.github.io/docs/Classes/ORKConsentSignature.html)                                                                                                                   |

| Patient Cloud Control | ResearchKit Control                                                                                                                                                                     |
| --------------        | ---------                                                                                                                                                                               |
| Calendar Control      | [ORKDateAnswerFormat](https://researchkit.github.io/docs/Classes/ORKDateAnswerFormat.html)                                                                                              |
| Timestamp             | [ORKTimeOfDayAnswerFormat](https://researchkit.github.io/docs/Classes/ORKTimeOfDayAnswerFormat.html)                                                                                    |
| Acknowledgement       | [ORKConsentReviewStep](http://researchkit.github.io/docs/Classes/ORKConsentReviewStep.html) + [ORKConsentSignature](http://researchkit.github.io/docs/Classes/ORKConsentSignature.html) |
| NoCloudDisplay        | N/A                                                                                                                                                                                     |
| Wong Baker            | [ORKImageChoiceAnswerFormat](https://researchkit.github.io/docs/Classes/ORKImageChoiceAnswerFormat.html)                                                                                |
| Bristol               | [ORKImageChoiceAnswerFormat](https://researchkit.github.io/docs/Classes/ORKImageChoiceAnswerFormat.html) can be subclassed to add support for vertical images                           |
| VAS / VAS with Box    | [ORKScaleAnswerFormat](https://researchkit.github.io/docs/Classes/ORKScaleAnswerFormat.html)                                                                                            |
| NRS                   | [ORKScaleAnswerFormat](https://researchkit.github.io/docs/Classes/ORKScaleAnswerFormat.html)                                                                                            |



## Specific Control Types

### Text
ResearchKit Object: `ORKTextAnswerFormat` or `ORKNumericAnswerFormat`

Depending on the nature of the data, either text or a numeric value can be captured.


### Date / Time
ResearchKit Object: `ORKDateAnswerFormat` or `ORKTimeIntervalAnswerFormat` or `ORKTimeOfDayAnswerFormat`

While technically the DateTime control could be represented by an `ORKTextAnswerFormat` control, using an `ORKDateAnswerFormat` will avoid the need to implement complicated Date validations.


### Drop Down List / Radio Button
Used to produce a sequence of Radio Buttons or a Drop Down

ResearchKit Object: `ORKTextChoiceAnswerFormat` or `ORKValuePickerAnswerFormat`

An `ORKTextChoiceAnswerFormat` will list all options at once, whereas a `ORKValuePickerAnswerFormat` provides
a scrollable list that shows only a view items at once.

| Rave Architect Field | ResearchKit Field            |
| -------------------  | ------------------------     |
| Data Dictionary      | `NSArray` of `ORKTextChoice` |
| User Data String     | `ORKTextChoice.text`         |
| Coded Data           | `ORKTextChoice.value`        |


### Signature
ResearchKit Object: `ORKConsentReviewStep` + `ORKConsentSignature`

The `ORKConsentReviewStep` can be used to ask a subject for their consent and can produce an `ORKConstentSignature` instance containing the relevant data.


## Active Tasks

ResearchKit provides [Active Tasks](https://researchkit.github.io/docs/docs/ActiveTasks/ActiveTasks.html) for collecting data under "partial controlled conditions." Such tasks may include walking for a period of time, tapping the screen repeatedly, or completing a task to test memory.

Active Tasks return a hierarchy of `ORKResult` objects containing the collected data. If the data is too large, it will be saved to a file and an `ORKFileResult` object will be returned. Additionally, a `ORKRecorderConfiguration` can be attached to an Active Step to process data while it is being collected.

## Formatting and Validation

The following Answer Formats provide basic input validation:

| ResearchKit Object               | Validation properties                         |
| ------------------               | ---------------------                         |
| `ORKNumericAnserFormat`          | `minimum`, `maximum`                          |
| `ORKScaleAnswerFormat`           | `minimum`, `maximum`, `step`                  |
| `ORKContinuousScaleAnswerFormat` | `minimum`, `maximum`, `maximumFractionDigits` |
| `ORKTextAnswerFormat`            | `maximumLength`, `multipleLines`              |
| `ORKDateAnswerFormat`            | `minimumDate`, `maximumDate`                  |

Basic Rave Formatting and Validation can be implemented in ResearchKit using the following:

| Rave Formatting | ResearchKit Equivalent                                                                                                    |
| --------------- | ----------------------                                                                                                    |
| $x              | `ORKTextAnswerFormat.maximumLength = x`                                                                                   |
| n               | `ORKNumericAnswerFormat.maximum = pow(10, n) - 1`                                                                         |
| n+              | `ORKNumericAnswerFormat.minimum = pow(10, n-1)` `ORKNumericAnswerFormat.maximum = pow(10,n) - 1`                          |

For more advanced validations, the `didFinishWithNavigationDirection` and `stepViewControllerResultDidChange` methods from the [ORKStepViewControllerDelegate](https://researchkit.github.io/docs/Protocols/ORKStepViewControllerDelegate.html) may be implemented for finer-grained control over step navigation. Additionally the `shouldPresentStep` method from the [ORKTaskViewControllerDelegate](https://researchkit.github.io/docs/Protocols/ORKTaskViewControllerDelegate.html) may also be suitable for disallowing navigation after the user submits invalid data.


## Branching Questions / Edit Checks
While Edit Check execution is not yet supported, dynamic Field visibility based on results can be accomplished by subclassing `ORKOrderedTask`, overriding the `stepAfterStep` and `stepBeforeStep` methods. An example can be found in the [ResearchKit Documentation](http://researchkit.github.io/docs/docs/Survey/CreatingSurveys.html).
