<p align="center">
   <img width="200px" src="/assets/xcode.png">
</p>
<h1 align="center">(Super Easy) Xcode TestRail Integration</h1>


![Build Status](https://github.com/boxblinkracer/xcode-testrail/actions/workflows/ci_pipe.yml/badge.svg)
[![Version](https://img.shields.io/cocoapods/v/XcodeTestrail.svg?style=flat)](https://cocoapods.org/pods/xcode-testrail)
[![License](https://img.shields.io/cocoapods/l/XcodeTestrail.svg?style=flat)](https://cocoapods.org/pods/xcode-testrail)
[![Platform](https://img.shields.io/cocoapods/p/XcodeTestrail.svg?style=flat)](https://cocoapods.org/pods/xcode-testrail)

This integration helps you to automatically send test results to TestRail. And yes, super easy and simple!

Add your TestRail credentials in Xcode, decide which test results should be sent to TestRail and you're done!


### 1. Installation

This integration is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

You usually only need to install the integration for your `test targets`.
Open your podfile and add this to your test target.

```bash 
target 'MyTestTarget' do
    pod 'XcodeTestrail'
end
```

Then just install your pods.

```bash 
pod install
```



### 2. Setup TestRail credentials

Now configure your credentials for the TestRail API.
Just add this snippet in a `testrail.conf` file in the root directory of your project.

```ini 
TESTRAIL_DOMAIN=xxx.testrail.io
TESTRAIL_USER=xxx
TESTRAIL_PWD=xxxx
```


### 3. Setup Mode

#### 3.1 Send result to specific Run in TestRail

Just assign the Run ID of TestRail in your `testrail.conf` and all results will be sent to this run.

Results will only be saved, if the sent TestCaseID is also existing in that run inside TestRail.

```ini 
TESTRAIL_RUN_ID=161
```


#### 3.2 Create new Run in TestRail for every Xcode run

Sometimes you want to create test runs dynamically inside TestRail.
For this, just assign the ProjectID and the optional MilestoneID of TestRail in your `testrail.conf`.

The integration will then start a new run in TestRail and send the results to this one.
It is also possible to provide a custom (or dynamically created) name for the new test run.

```ini 
TESTRAIL_PROJECT_ID=14                      // required project id
TESTRAIL_MILESTONE_ID=5                     // optional, a milestone if yo have one
TESTRAIL_RUN_NAME=XCODE RUN iPhone 14       // the name you want to use for this test run
TESTRAIL_CLOSE_RUN=true                     // optional, if you want to close a run automatically. default is FALSE
```


### 4. Register Plugin

Just register the TestRail integration in the setup of your test files.
Also make sure to import the module with the `@testable` keyword, otherwise TestRail will not be found!

There's nothing more that is required to register the TestRail reporter.

```javascript 
@testable import XcodeTestrail

override func setUpWithError() throws
{
    try super.setUpWithError()

    TestRail().register();
}
```


### 5. Map Test Cases

We're almost done.
You can now map TestRail test cases to your Xcode tests.
Please use the TestRail case ID as a suffix inside the Xcode test title.
The plugin will automatically extract it, and send the results to your test run in TestRail.
The case ID needs to be at the end and separated with an `_` from the rest of the title.

```javascript 
public func testMyFeature_C6437()
{
    // ...
}
```

## That's it!

You can now start Xcode, and all your results should be sent to TestRail as soon as your mapped tests pass or fail!



# CI/CD Pipelines

It's also possible to run the integration within a CI/CD pipeline.
In most cases you probably want to create separate test runs for different devices.

I would recommend creating a `Test Plan` in TestRail.
This plan can then contain different test runs for every device.

<p align="center">
   <img width="100%" src="/assets/testrail_plan.png">
</p>

In your pipeline, just create a `testrail.conf` file and fill it with the RunID for the specific device test.
You can either create the full file dynamically, or maybe create a template that comes without a run id.
In that case we simply copy the template before we start the test, and then add our specific run id.

```yaml  
# template.conf
TESTRAIL_DOMAIN=xxx.testrail.io
TESTRAIL_USER=xxx
TESTRAIL_PWD=xxxx
```

```bash  
# copy template before a new device test
cp ./template.conf src/testrail.conf

# assign our iPhone 14 Pro (iOS 16.0) Run ID for our Release Plan in TestRail (R166)
echo "TESTRAIL_RUN_ID=166" >> src/testrail.conf

# start our Xcode tests for iPhone 14 Pro, iOS 16.0
xcodebuild test -workspace xxx -scheme xxx -testPlan UITestsPlan -destination 'platform=iOS Simulator,name=iPhone 14 Pro,OS=16.0'
```


## License

XcodeTestrail is available under the MIT license. See the LICENSE file for more info.
