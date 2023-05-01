# PlotView

[![CI Status](https://img.shields.io/travis/dzhagaz/PlotView.svg?style=flat)](https://travis-ci.org/dzhagaz/PlotView)
[![Version](https://img.shields.io/cocoapods/v/PlotView.svg?style=flat)](https://cocoapods.org/pods/PlotView)
[![License](https://img.shields.io/cocoapods/l/PlotView.svg?style=flat)](https://cocoapods.org/pods/PlotView)
[![Platform](https://img.shields.io/cocoapods/p/PlotView.svg?style=flat)](https://cocoapods.org/pods/PlotView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 15.

## Usage

Create a proper view model for your plot view and pass it into your SwiftUI PlotView.

### Create a view model example:

```swift
PlotView.ViewModel.Impl {

    /// Specify records, it supports four types of records (blocks, functions, points, and grids).
    $0.records = [

        .init(

            item: .block(.init(

                    width: 30,
                    origin: .init(xCoordinate: 20, yCoordinate: 60),
                    toColor: nil,
                    fromColor: nil
            ))
        ),
    ]

    /// Specify the limit value for each axis, if you want it to be limited to a specific value. By default, the view is adjusted to fit its records.
    $0.xConfig.limitConfig = .fixed(value: 300)
    $0.yConfig.limitConfig = .fixed(value: 100)

    /// Specify the label count for each axis. If it is set to zero, labels are hidden, and graph content is adjusted.
    $0.yConfig.labelCount = 6
    $0.xConfig.labelCount = 7

    /// Configure the proportional grid lines appearance.
    $0.xConfig.showGrid = false

    /// Specify the scale for the axis (in points per unit). By default, it is calculated automatically, and the axis is not scrollable.
    $0.xConfig.scaleConfig = .fixed(value: 0.5)
},
```

## Installation

PlotView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PlotView'
```

## Author

dzhagaz, dzhagaz.sasha@gmail.com

## License

PlotView is available under the MIT license. See the LICENSE file for more info.
