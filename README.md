# MORK

![logo](logo.png)

MORK is an extension of [Apple ResearchKit](https://github.com/ResearchKit/ResearchKit) that facilitates easy serialization of ResearchKit data into the form required by the Patient Cloud Gateway.

Contact us at mork@mdsol.com

## Properties

MORK adds a method to the ResearchKit `ORKCollectionResult` class via a
category:

#### `-(NSArray *)mork_getFieldDataFromResults;`

Returns an `NSArray` containing the data, identifier, and date-entered for each
`ORKStepResult` (if retrieving result data from an instance of `ORKTaskResult`)
or `ORKQuestionResult` (if retrieving result data from an instance of
`ORKStepResult`) in the `ORKCollectionResult` subclass:

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

The `NSArray` returned from the `mork_getFieldDataFromResults` method can be
converted to JSON and sent to the Patient Cloud Gateway to create an entry in
Rave. An example JSON payload is as follows:

```
{
  "form_data": {
    "subject_name": "aabb99",
    "log_line": 1,
    "study_uuid": "a2c0da8c-4dfd-4ffd-b3d5-94c762086c2f",
    "signature_date_time_entered": "2015-27-10T17:04:35",
    "folder_oid": "SUBJECT",
    "form_oid": "MYFORM",
    "field_data": [
      {
        "data_value": "M",
        "item_oid": "GENDER",
        "date_time_entered": "2015-27-10T17:03:24"
      },
      {
        "data_value": "1990-12-04T20:10:30",
        "item_oid": "DOB",
        "date_time_entered": "2015-27-10T17:03:37"
      },
      {
        "data_value": "Sometimes",
        "item_oid": "EXERCISE_FREQUENCY",
        "date_time_entered": "2015-27-10T17:03:48"
      },
      {
        "data_value": "7",
        "item_oid": "PAIN_LEVEL",
        "date_time_entered": "2015-27-10T17:03:56"
      }
    ],
    "site_oid": "Site",
    "version": "1.0",
    "device_id": "DFEBA156-C012-4AD2-957C-9995829BC3A7",
    "signature_oid": "ACK_FIELD",
    "rave_url": "http://rave-url.example.com",
    "study_name": "MyStudy",
    "record_oid": "PCFORM_LOG_LINE",
    "subject_uuid": "bfe72729-ab34-4f97-bf03-18ea61fdc92e"
  }
}
```

## `MORKExample` Example Project Documentation

- [Objective-C](/MORKExample/Objective-C/README.md).
- [Swift](/MORKExample/Swift/README.md).

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
