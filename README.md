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

Please keep in mind, the `runId` is always the test run, that you want to send the results to.
You can find the ID inside the test run in TestRail. It usually starts with an R, like "R68".

```ini 
TESTRAIL_DOMAIN=xxx.testrail.com
TESTRAIL_USER=xxx
TESTRAIL_PWD=xxxx
TESTRAIL_RUN_ID=161
```



### 3. Register Plugin

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


### 4. Map Test Cases

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

## License

xcode-testrail is available under the MIT license. See the LICENSE file for more info.
