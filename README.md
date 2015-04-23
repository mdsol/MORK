# Patient Cloud / ResearchKit Integration

## Common Fields
Most Rave fields can be represented by an ORKQuestionStep. Special fields such as consent forms and form submission can be represented by
other subclasses of ORKStep (ORKVisualConsentStep, ORKCompletionStep).

If multiple questions should be shown on a single, scrollable page, an ORKFormStep can be used to encapsulate multiple ORKSteps

Fields shared by all Rave Architect Fields:

| Rave Architect Field | ResearchKit Field                                    |
| -------------------  | ----------------                                     |
| FieldOID             | NSString Identifier                                  |
| Header Text          | `ORKStep.title`                                      |
| Field Label (?)      | `ORKStep.text`                                       |
| VariableFormat       | See [Formatting](#formatting-and-validation) Section |



## Control Types

Fields without corresponding ResearchKit Controls may not be supported out-of-the-box

| Rave Control        | ResearchKit Control                                                                                                                                                                                                                                                                                       |
| --------------      | ---------                                                                                                                                                                                                                                                                                                 |
| Text                | [ORKTextAnswerFormat](http://researchkit.github.io/docs/Classes/ORKTextAnswerFormat.html), [ORKNumericAnswerFormat](http://researchkit.github.io/docs/Classes/ORKNumericAnswerFormat.html)                                                                                                                |
| Long Text           | [ORKTextAnswerFormat](http://researchkit.github.io/docs/Classes/ORKTextAnswerFormat.html)                                                                                                                                                                                                                 |
| Date Time           | [ORKDateAnswerFormat](http://researchkit.github.io/docs/Classes/ORKDateAnswerFormat.html), [ORKTimeIntervalAnswerFormat](http://researchkit.github.io/docs/Classes/ORKTimeIntervalAnswerFormat.html), [ORKTimeOfDayAnswerFormat](http://researchkit.github.io/docs/Classes/ORKTimeOfDayAnswerFormat.html) |
| Check Box           | [ORKTextChoiceAnswerFormat](http://researchkit.github.io/docs/Classes/ORKTextChoiceAnswerFormat.html)                                                                                                                                                                                                     |
| Drop Down List      | [ORKTextChoiceAnswerFormat](http://researchkit.github.io/docs/Classes/ORKTextChoiceAnswerFormat.html)                                                                                                                                                                                                     |
| Radio Button        | [ORKTextChoiceAnswerFormat](http://researchkit.github.io/docs/Classes/ORKTextChoiceAnswerFormat.html)                                                                                                                                                                                                     |
| Signature           | [ORKConsentReviewStep](http://researchkit.github.io/docs/Classes/ORKConsentReviewStep.html) + [ORKConsentSignature](http://researchkit.github.io/docs/Classes/ORKConsentSignature.html)                                                                                                                   |
| Search List         |                                                                                                                                                                                                                                                                                                           |
| Dynamic Search List |                                                                                                                                                                                                                                                                                                           |
| File Upload         |                                                                                                                                                                                                                                                                                                           |

Many Patient Cloud controls also have ResearchKit equivalents:

| Patient Cloud Control | ResearchKit Control                                                                                                                                                                     |
| --------------        | ---------                                                                                                                                                                               |
| Calendar Control      | [ORKDateAnswerFormat](https://researchkit.github.io/docs/Classes/ORKDateAnswerFormat.html)                                                                                              |
| Timestamp             | [ORKTimeOfDayAnswerFormat](https://researchkit.github.io/docs/Classes/ORKTimeOfDayAnswerFormat.html)                                                                                    |
| Acknowledgement       | [ORKConsentReviewStep](http://researchkit.github.io/docs/Classes/ORKConsentReviewStep.html) + [ORKConsentSignature](http://researchkit.github.io/docs/Classes/ORKConsentSignature.html) |
| NoCloudDisplay        | N/A                                                                                                                                                                                     |
| Wong Baker            | [ORKImageChoiceAnswerFormat](https://researchkit.github.io/docs/Classes/ORKImageChoiceAnswerFormat.html)                                                                                |
| Bristol               | ORKImageChoiceAnswerFormat can be subclassed to add support for vertical images                                                                                                         |
| VAS / VAS with Box    | [ORKScaleAnswerFormat](https://researchkit.github.io/docs/Classes/ORKScaleAnswerFormat.html)                                                                                            |
| NRS                   | [ORKScaleAnswerFormat](https://researchkit.github.io/docs/Classes/ORKScaleAnswerFormat.html)                                                                                            |



## Specific Control Types

### Text & Long Text
RK Control: ORKTextAnswerFormat or ORKNumericAnswerFormat

Depending on the nature of the data, either text or a numeric value can be captured.


### Date / Time
RK Control: ORKDateAnswerFormat or ORKTimeIntervalAnswerFormat or ORKTimeOfDayAnswerFormat

While technically the DateTime control could be represented by an ORKTextAnswerFormat control, using an ORKDateAnswerFormat will avoid the need to implement complicated Date validations.


### Check Box
RK Control: ORKTextChoiceAnswerFormat

Specifying the `ORKChoiceAnswerStyleMultipleChoice` when creating a question with ORKTextChoiceAnswerFormat will allow the user to select multiple choices.

| Rave Architect Field | ResearchKit Field        |
| -------------------  | ------------------------ |
| Data Dictionary      | NSArray of ORKTextChoice |
| User Data String     | `ORKTextChoice.text`     |
| Coded Data           | `ORKTextChoice.value`    |


### Drop Down List / Radio Button
Used to produce a sequence of Radio Buttons or a Drop Down

RK Control: ORKTextChoiceAnswerFormat or ORKValuePickerAnswerFormat

An ORKTextChoiceAnswerFormat will list all options at once, whereas a ORKValuePickerAnswerFormat provides
a scrollable list that shows only a view items at once.

| Rave Architect Field | ResearchKit Field        |
| -------------------  | ------------------------ |
| Data Dictionary      | NSArray of ORKTextChoice |
| User Data String     | `ORKTextChoice.text`     |
| Coded Data           | `ORKTextChoice.value`    |


### Signature
RK Control: ORKConsentReviewStep + ORKConsentSignature

The ORKConsentReviewStep can be used to ask a subject for their consent and can produce an ORKConstentSignature instance containing the relevant data.


## Active Tasks

ResearchKit provides [active tasks](https://researchkit.github.io/docs/docs/ActiveTasks/ActiveTasks.html) for collecting data under "partial controlled conditions." Such tasks may include walking for a period of time, tapping the screen repeatedly, or completing a task to test memory.

Active tasks return an `ORKResult` object containing numerical data which can be converted into whatever form is needed by your application.

## Formatting and Validation
Each Answer Format provides basic validation. Numeric options provide minumum and maximum constraints. Text fields allow for minimum and maximum lengths. Date fields allow for minimum and maximum dates.

Basic Rave Formatting and Validation can be implemented in ResearchKit using the following:

| Rave Formatting | ResearchKit Equivalent                                                                                                    |
| --------------- | ----------------------                                                                                                    |
| $x              | `ORKTextAnswerFormat.maximumLength = x`                                                                                   |
| n               | `ORKNumericAnswerFormat.maximum = pow(10, n) - 1`                                                                         |
| n+              | `ORKNumericAnswerFormat.minimum = pow(10, n-1)` `ORKNumericAnswerFormat.maximum = pow(10,n) - 1`                          |
| n.n, n.x, etc.. | Decimals are allow via the `style`, but the options are not fine-grained                                                  |
| Date Formats    | Using specific controls + `style` options allows for selection of just date, date + time, time of day, and time intervals |
| nn              | `ORKNumericAnswerFormat.minimum = 1` `ORKNumericAnswerFormat.maximum = 59`                                                |
| ss              | `ORKNumericAnswerFormat.minimum = 1` `ORKNumericAnswerFormat.maximum = 59`                                                |
| rr              | Can use an ORKValuePickerAnswerFormat to restrict to AM, PM                                                               |

For more advanced validations, the [ORKStepViewControllerDelegate](https://researchkit.github.io/docs/Protocols/ORKStepViewControllerDelegate.html) can be implemented. This delegate provides methods for finer-grained control over individual steps.

