//
//  PlotView+View.swift
//  PlotView
//
//  Created by dzhagaz on 27.04.2023.
//

import SwiftUI

extension PlotView {

    public struct View: SwiftUI.View {

        @ObservedObject var viewModel: ViewModel.Interface

        public init(viewModel: ViewModel.Interface) {

            self.viewModel = viewModel
        }

        public var body: some SwiftUI.View {

            GeometryReader { geometry in

                let xAxisLimitValue = viewModel.xAxisLimitValue
                let yAxisLimitValue = viewModel.yAxisLimitValue
                let xOffset = viewModel.xLabelVMs.isEmpty ? 0 : LayoutConstants.yAxisLabelWidth
                let yOffset = viewModel.yLabelVMs.isEmpty ? 0 : LayoutConstants.xAxisLabelHeight
                let xScale = scale(

                    with: viewModel.xConfig.scaleConfig,
                    axisLength: Float(geometry.size.width),
                    contentValue: xAxisLimitValue,
                    axisOffset: 0
                )
                let yScale = scale(

                    with: viewModel.yConfig.scaleConfig,
                    axisLength: Float(geometry.size.height),
                    contentValue: yAxisLimitValue,
                    axisOffset: 0
                )
                let xScaleOffset = scale(

                    with: viewModel.xConfig.scaleConfig,
                    axisLength: Float(geometry.size.width - xOffset),
                    contentValue: xAxisLimitValue,
                    axisOffset: Float(xOffset)
                )
                let yScaleOffset = scale(

                    with: viewModel.yConfig.scaleConfig,
                    axisLength: Float(geometry.size.height - yOffset),
                    contentValue: yAxisLimitValue,
                    axisOffset: Float(yOffset)
                )

                let contentView = ZStack {

                    let limitSize = CGSize(

                        width: CGFloat(max(xAxisLimitValue, 1)),
                        height: CGFloat(max(yAxisLimitValue, 1))
                    )

                    ForEach(viewModel.xGridLineVMs) { gridVM in

                        Path { path in

                            path.move(to: CGPoint(

                                x: (CGFloat(xAxisLimitValue * xScaleOffset) * gridVM.relativePosition) +
                                xOffset,
                                y: 0
                            ))
                            path.addLine(to: CGPoint(

                                x: (CGFloat(xAxisLimitValue * xScaleOffset) * gridVM.relativePosition) +
                                xOffset,
                                y: CGFloat(yAxisLimitValue * yScaleOffset)
                            ))
                        }

                        .strokedPath(StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Colors.fill)
                    }

                    ForEach(viewModel.yGridLineVMs) { gridVM in

                        Path { path in

                            path.move(to: CGPoint(

                                x: xOffset,
                                y: (CGFloat(yAxisLimitValue * yScaleOffset) * gridVM.relativePosition)
                            ))
                            path.addLine(to: CGPoint(

                                x: CGFloat(xAxisLimitValue * xScaleOffset) + xOffset,
                                y: (CGFloat(yAxisLimitValue * yScaleOffset) * gridVM.relativePosition)
                            ))
                        }

                        .strokedPath(StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Colors.fill)
                    }

                    ForEach(viewModel.records) { record in

                        switch record.item {

                        case .grid(let grid):

                            Path { path in

                                let first = convertedPoint(

                                    for: .init(

                                        x: CGFloat(grid.first.xCoordinate),
                                        y: CGFloat(grid.first.yCoordinate)
                                    ),
                                    to: geometry.size,
                                    with: limitSize,
                                    xScale: CGFloat(xScaleOffset),
                                    yScale: CGFloat(yScaleOffset),
                                    xOffset: xOffset
                                )
                                let last = convertedPoint(

                                    for: .init(

                                        x: CGFloat(grid.last.xCoordinate),
                                        y: CGFloat(grid.last.yCoordinate)
                                    ),
                                    to: geometry.size,
                                    with: limitSize,
                                    xScale: CGFloat(xScaleOffset),
                                    yScale: CGFloat(yScaleOffset),
                                    xOffset: xOffset
                                )
                                let xDistance = last.x - first.x
                                let yDistance = last.y - first.y
                                let distance = sqrt(pow(xDistance, 2) + pow(yDistance, 2))
                                let count = distance / LayoutConstants.gridPatternWidth
                                let intCount = Int(count)
                                let xStep = xDistance / count
                                let yStep = yDistance / count
                                var point = first

                                path.move(to: point)

                                switch grid.pattern {

                                case .lineDot:

                                    for _ in 0 ..< intCount {

                                        path.addLine(

                                            to: .init(

                                                x: point.x + xStep * 0.5,
                                                y: point.y + yStep * 0.5
                                        ))
                                        path.move(

                                            to: .init(

                                                x: point.x + xStep * 0.75,
                                                y: point.y + yStep * 0.75
                                        ))
                                        path.addLine(

                                            to: .init(

                                                x: point.x + xStep * 0.75,
                                                y: point.y + yStep * 0.75
                                        ))
                                        path.move(

                                            to: .init(

                                                x: point.x + xStep,
                                                y: point.y + yStep
                                        ))
                                        point.x += xStep
                                        point.y += yStep
                                    }
                                    path.addLine(to: last)

                                case .line:

                                    for _ in 0 ..< intCount {

                                        path.addLine(

                                            to: .init(

                                                x: point.x + xStep * 0.7,
                                                y: point.y + yStep * 0.7
                                        ))
                                        path.move(

                                            to: .init(

                                                x: point.x + xStep,
                                                y: point.y + yStep
                                        ))
                                        point.x += xStep
                                        point.y += yStep
                                    }
                                    path.addLine(to: last)

                                case .dot:

                                    var length: Double = 0
                                    while length < distance {

                                        path.addLine(

                                            to: .init(

                                                x: point.x + xStep * 0.05,
                                                y: point.y + yStep * 0.05
                                        ))
                                        path.move(

                                            to: .init(

                                                x: point.x + xStep * 0.45,
                                                y: point.y + yStep * 0.45
                                        ))
                                        path.addLine(

                                            to: .init(

                                                x: point.x + xStep * 0.55,
                                                y: point.y + yStep * 0.55
                                        ))
                                        path.move(

                                            to: .init(

                                                x: point.x + xStep,
                                                y: point.y + yStep
                                        ))
                                        point.x += xStep
                                        point.y += yStep

                                        length += LayoutConstants.gridPatternWidth
                                    }
                                }

                            } // Path

                            .strokedPath(StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                            .foregroundColor(grid.color ?? Colors.fill)

                        case .point(let point):

                            Path { path in

                                let convertedPoint = convertedPoint(

                                    for: .init(

                                        x: CGFloat(point.coordinates.xCoordinate),
                                        y: CGFloat(point.coordinates.yCoordinate)
                                    ),
                                    to: geometry.size,
                                    with: limitSize,
                                    xScale: CGFloat(xScaleOffset),
                                    yScale: CGFloat(yScaleOffset),
                                    xOffset: xOffset
                                )
                                path.move(to: convertedPoint)
                                path.addLine(to: convertedPoint)

                            } // Path

                            .strokedPath(StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                            .foregroundColor(point.color ?? Colors.fill)

                        case .block(let block):

                            Path { path in

                                let controlPoint1 = convertedPoint(

                                    for: .init(

                                        x: CGFloat(block.origin.xCoordinate),
                                        y: CGFloat(block.origin.yCoordinate)
                                    ),
                                    to: geometry.size,
                                    with: limitSize,
                                    xScale: CGFloat(xScaleOffset),
                                    yScale: CGFloat(yScaleOffset),
                                    xOffset: xOffset
                                )
                                let controlPoint2 = convertedPoint(

                                    for: .init(

                                        x: CGFloat(block.origin.xCoordinate + block.width),
                                        y: CGFloat(block.origin.yCoordinate)
                                    ),
                                    to: geometry.size,
                                    with: limitSize,
                                    xScale: CGFloat(xScaleOffset),
                                    yScale: CGFloat(yScaleOffset),
                                    xOffset: xOffset
                                )
                                let controlPoint3 = convertedPoint(

                                    for: .init(

                                        x: CGFloat(block.origin.xCoordinate + block.width),
                                        y: 0
                                    ),
                                    to: geometry.size,
                                    with: limitSize,
                                    xScale: CGFloat(xScaleOffset),
                                    yScale: CGFloat(yScaleOffset),
                                    xOffset: xOffset
                                )
                                let controlPoint4 = convertedPoint(

                                    for: .init(

                                        x: CGFloat(block.origin.xCoordinate),
                                        y: 0
                                    ),
                                    to: geometry.size,
                                    with: limitSize,
                                    xScale: CGFloat(xScaleOffset),
                                    yScale: CGFloat(yScaleOffset),
                                    xOffset: xOffset
                                )

                                path.move(

                                    to: .init(

                                        x: controlPoint1.x + LayoutConstants.blockCornerRadius,
                                        y: controlPoint1.y
                                    )
                                )
                                path.addLine(to: .init(

                                    x: controlPoint2.x - LayoutConstants.blockCornerRadius,
                                    y: controlPoint2.y
                                ))
                                path.addCurve(

                                    to: .init(

                                        x: controlPoint2.x,
                                        y: controlPoint2.y + LayoutConstants.blockCornerRadius
                                    ),
                                    control1: controlPoint2,
                                    control2: controlPoint2
                                )
                                path.addLine(

                                    to: .init(

                                        x: controlPoint3.x,
                                        y: controlPoint3.y - LayoutConstants.blockCornerRadius
                                    )
                                )
                                path.addCurve(

                                    to: .init(

                                        x: controlPoint3.x - LayoutConstants.blockCornerRadius,
                                        y: controlPoint3.y
                                    ),
                                    control1: controlPoint3,
                                    control2: controlPoint3
                                )
                                path.addLine(

                                    to: .init(

                                        x: controlPoint4.x + LayoutConstants.blockCornerRadius,
                                        y: controlPoint4.y
                                    )
                                )
                                path.addCurve(

                                    to: .init(

                                        x: controlPoint4.x,
                                        y: controlPoint4.y - LayoutConstants.blockCornerRadius
                                    ),
                                    control1: controlPoint4,
                                    control2: controlPoint4
                                )
                                path.addLine(

                                    to: .init(

                                        x: controlPoint1.x,
                                        y: controlPoint1.y + LayoutConstants.blockCornerRadius
                                    )
                                )
                                path.addCurve(

                                    to: .init(

                                        x: controlPoint1.x + LayoutConstants.blockCornerRadius,
                                        y: controlPoint1.y
                                    ),
                                    control1: controlPoint1,
                                    control2: controlPoint1
                                )

                            } // Path

                            .fill(LinearGradient(

                                gradient: Gradient(colors: [

                                    block.fromColor ?? Colors.fill,
                                    block.toColor ?? Colors.fill,
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))

                        case .function(let function):

                            Path { path in

                                if let first = function.points.last {

                                    path.move(to: convertedPoint(

                                        for: .init(

                                            x: CGFloat(first.xCoordinate),
                                            y: CGFloat(first.yCoordinate)
                                        ),
                                        to: geometry.size,
                                        with: limitSize,
                                        xScale: CGFloat(xScaleOffset),
                                        yScale: CGFloat(yScaleOffset),
                                        xOffset: xOffset
                                    ))
                                }
                                for point in function.points.reversed() {

                                    path.addLine(to: convertedPoint(

                                        for: .init(

                                            x: CGFloat(point.xCoordinate),
                                            y: CGFloat(point.yCoordinate)
                                        ),
                                        to: geometry.size,
                                        with: limitSize,
                                        xScale: CGFloat(xScaleOffset),
                                        yScale: CGFloat(yScaleOffset),
                                        xOffset: xOffset
                                    ))
                                }

                            } // Path

                            .strokedPath(StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                            .foregroundColor(function.color ?? Colors.stroke)
                        }

                    } // ForEach

                    HStack(spacing: 0) {

                        if !viewModel.yLabelVMs.isEmpty {

                            VStack(alignment: .leading, spacing: 0) {

                                ForEach(viewModel.yLabelVMs) { label in

                                    Text(label.value)

                                        .font(.system(size: 11))
                                        .foregroundColor(Colors.stroke)
                                        .frame(maxHeight: LayoutConstants.xAxisLabelHeight)
                                        .frame(width: LayoutConstants.yAxisLabelWidth)

                                    if label.id != viewModel.yLabelVMs.last?.id {

                                        Spacer()

                                    } else {

                                        Spacer()

                                            .frame(height: LayoutConstants.xAxisLabelHeight)

                                    }

                                } // ForEach

                            } // VStack

                            .frame(width: LayoutConstants.yAxisLabelWidth)
                        }

                        if viewModel.xLabelVMs.isEmpty {

                            Spacer()
                        }

                        VStack(spacing: 0) {

                            Spacer()

                            if !viewModel.xLabelVMs.isEmpty {

                                HStack(spacing: 0) {

                                    ForEach(viewModel.xLabelVMs) { label in

                                        Text(label.value)

                                            .font(.system(size: 11))
                                            .foregroundColor(Colors.stroke)
                                            .frame(

                                                width: LayoutConstants.yAxisLabelWidth,
                                                height: LayoutConstants.xAxisLabelHeight
                                            )

                                        if label.id != viewModel.xLabelVMs.last?.id {

                                            Spacer()
                                        }

                                    } // ForEach

                                } // HStack

                                .frame(height: LayoutConstants.xAxisLabelHeight)
                            }

                        } // VStack

                    } // HStack

                } // ZStack

                .frame(

                    width: CGFloat(xScale * xAxisLimitValue),
                    height: CGFloat(yScale * yAxisLimitValue)
                )

                let xScrollable = xAxisLimitValue * xScale > Float(geometry.size.width)
                let yScrollable = yAxisLimitValue * yScale > Float(geometry.size.height)

                switch (xScrollable, yScrollable) {
                case (false, false):
                    VStack(spacing: 0) {

                        contentView

                    } // VStack
                case (true, false):
                    ScrollView([.horizontal], showsIndicators: false) {

                        contentView

                    } // ScrollView
                case (false, true):
                    ScrollView([.vertical], showsIndicators: false) {

                        contentView

                    } // ScrollView
                case (true, true):
                    ScrollView([.horizontal, .vertical], showsIndicators: false) {

                        contentView

                    } // ScrollView
                }

            } // GeometryReader

        } // body

        // MARK: Privates

        private typealias Config = PlotView.ViewModel.AxisDisplayConfig.Config

        private struct Colors {

            static let fill = Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
            static let stroke = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }

        private struct LayoutConstants {

            static let yAxisLabelWidth: CGFloat = 40
            static let xAxisLabelHeight: CGFloat = 20
            static let gridPatternWidth: CGFloat = 15
            static let blockCornerRadius: CGFloat = 6
        }

        private func scale(

            with config: Config,
            axisLength: Float,
            contentValue: Float,
            axisOffset: Float

        ) -> Float {

            switch config {
            case .fixed(let value):

                let points = value * contentValue

                return value * ((points - axisOffset) / points)

            case .dynamic: return axisLength / contentValue
            }
        }

        func convertedPoint(

            for point: CGPoint,
            to size: CGSize,
            with limit: CGSize,
            xScale: CGFloat,
            yScale: CGFloat,
            xOffset: CGFloat

        ) -> CGPoint {

            let xCoordinate = point.x * xScale
            let yCoordinate = (limit.height * yScale) - (point.y * yScale)

            return CGPoint(x: xCoordinate + xOffset, y: yCoordinate)
        }

    } // View

} // PlotView

#if DEBUG

struct PlotView_Preview_Provider: PreviewProvider {

    static var previews: some SwiftUI.View {

        VStack {

            View(viewModel: staticContext.frozen)
            View(viewModel: staticContext.hScrollable)
            View(viewModel: staticContext.vScrollable)
            View(viewModel: staticContext.fullScrollable)
            View(viewModel: staticContext.empty)
        }

        .padding()
    }

    private typealias View = PlotView.View
    private typealias ViewModel = PlotView.ViewModel
    private typealias Record = ViewModel.Record

    private final class Context: ObservableObject {

        let frozen: ViewModel.Interface
        let hScrollable: ViewModel.Interface
        let vScrollable: ViewModel.Interface
        let fullScrollable: ViewModel.Interface
        let empty: ViewModel.Interface

        init() {

            var records: [Record] = [

                .init(

                    item: .block(.init(

                        width: 300,
                        origin: .init(xCoordinate: 180, yCoordinate: 100),
                        toColor: Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)),
                        fromColor: Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
                    ))
                ),
                .init(

                    item: .block(.init(

                        width: 300,
                        origin: .init(xCoordinate: 600, yCoordinate: 150),
                        toColor: Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
                        fromColor: Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
                    ))
                ),
                .init(

                    item: .block(.init(

                        width: 300,
                        origin: .init(xCoordinate: 1080, yCoordinate: 200),
                        toColor: Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)),
                        fromColor: Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
                    ))
                ),
                .init(

                    item: .block(.init(

                        width: 200,
                        origin: .init(xCoordinate: 1500, yCoordinate: 280),
                        toColor: nil,
                        fromColor: nil
                    ))
                ),
            ]
            let testRanges: [(width: Int, range: ClosedRange<Float>)] = [

                (width: 150, range:0...0),
                (width: 350, range:120...130),
                (width: 80, range:0...0),
                (width: 350, range:160...180),
                (width: 130, range:0...0),
                (width: 350, range:210...230),
                (width: 80, range:0...0),
                (width: 230, range:280...300),
                (width: 80, range:0...0),
            ]
            var offset: Float = 0
            var points: [Record.Item.Coordinates] = []
            for range in testRanges {

                for _ in 0..<range.width {

                    offset += 1
                    points.append(

                        .init(

                            xCoordinate: offset,
                            yCoordinate: Float.random(in: range.range)
                        ))
                }
            }
            records.append(.init(item: .function(.init(points: points, color: nil))))

            self.frozen = ViewModel.Impl {

                $0.records = records
                $0.yConfig.showGrid = false
            }
            self.hScrollable = ViewModel.Impl {

                $0.records = records
                $0.xConfig.scaleConfig = .fixed(value: 0.4)
                $0.yConfig.showGrid = false
                $0.xConfig.showGrid = true
            }
            self.vScrollable = ViewModel.Impl {

                $0.records = records
                $0.yConfig.scaleConfig = .fixed(value: 0.5)
            }
            self.fullScrollable = ViewModel.Impl {

                $0.records = records
                $0.xConfig.scaleConfig = .fixed(value: 0.4)
                $0.yConfig.scaleConfig = .fixed(value: 0.5)
            }
            self.empty = ViewModel.Impl {

                $0.xConfig.limitConfig = .fixed(value: 1800)
                $0.yConfig.limitConfig = .fixed(value: 400)
                $0.xConfig.showGrid = true
            }
        }

    } // Context

    private static var staticContext: Context = {

        return .init()
    }()

} // PlotView_Preview_Provider

#endif
