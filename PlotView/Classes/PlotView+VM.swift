//
//  PlotView+VM.swift
//  PlotView
//
//  Created by dzhagaz on 27.04.2023.
//

import SwiftUI
import Foundation

extension PlotView {

    public struct ViewModel {

        public struct Record: Hashable, Identifiable {

            public enum Item: Equatable, Hashable {

                public struct Coordinates: Equatable, Hashable {

                    let xCoordinate: Float
                    let yCoordinate: Float

                    public init(

                        xCoordinate: Float,
                        yCoordinate: Float

                    ) {

                        self.xCoordinate = xCoordinate
                        self.yCoordinate = yCoordinate
                    }

                } // Coordinates

                public struct Point: Equatable, Hashable {

                    let coordinates: Coordinates
                    let color: Color?

                    public init(

                        coordinates: Coordinates,
                        color: Color?
                    ) {

                        self.coordinates = coordinates
                        self.color = color
                    }

                } // Point

                public struct Grid: Equatable, Hashable {

                    public enum Pattern: String {

                        case dot
                        case line
                        case lineDot

                    } // Pattern

                    let last: Coordinates
                    let first: Coordinates
                    let pattern: Pattern
                    let color: Color?

                    public init(

                        last: Coordinates,
                        first: Coordinates,
                        pattern: Pattern,
                        color: Color?

                    ) {

                        self.last = last
                        self.first = first
                        self.pattern = pattern
                        self.color = color
                    }

                } // Grid

                public struct Block: Equatable, Hashable {

                    let width: Float
                    let origin: Coordinates
                    let toColor: Color?
                    let fromColor: Color?

                    public init(

                        width: Float,
                        origin: Coordinates,
                        toColor: Color?,
                        fromColor: Color?

                    ) {

                        self.width = width
                        self.origin = origin
                        self.toColor = toColor
                        self.fromColor = fromColor
                    }

                } // Block

                public struct Function: Equatable, Hashable {

                    let points: [Coordinates]
                    let color: Color?

                    public init(

                        points: [Coordinates],
                        color: Color?

                    ) {

                        self.points = points
                        self.color = color
                    }

                } // Function

                case grid(Grid)
                case point(Point)
                case block(Block)
                case function(Function)

            } // Item

            /// Id of the record.
            ///
            public let id = UUID()

            /// The item to draw.
            ///
            public let item: Item

            public init(item: Item) {

                self.item = item
            }

        } // Record

        public struct AxisDisplayConfig {

            public enum Config: Equatable {

                /// Defines axis value limit from max value for axis.
                ///
                case dynamic

                /// Sticks axis value limit to specified value (value should be greater than max value for the axis).
                ///
                case fixed(value: Float)

            } // LimitConfig

            public enum ValueFormat {

                /// Display the axis label as an integer number.
                ///
                case int

                /// Display the axis label time interval.
                ///
                case time

                /// Provide the custom formatter.
                ///
                case custom((Float) -> String)

            } // ValueFormat

            /// Show grid lines for axis.
            ///
            public var showGrid: Bool

            /// Number of labels displayed across axis.
            ///
            public var labelCount: Int

            /// Limit config for the axis.
            /// Use .dynamic to allow view to determine its axis limit depending on records data.
            ///
            public var limitConfig: Config

            /// Scale config for the axis.
            /// Use .dynamic to force view to fit its content along axis and disable scrolling for axis.
            ///
            public var scaleConfig: Config

            /// The value formatter for the label values.
            ///
            public var valueFormat: ValueFormat = .int

        } // AxisDisplayConfig

        public struct AxisLabelVM: Identifiable {

            let value: String

            // MARK: - Identifiable

            public var id: Int
        }

        public struct AxisGridVM: Identifiable {

            let relativePosition: CGFloat

            // MARK: - Identifiable

            public let id: Int
        }

        public class Interface: ObservableObject, Identifiable {

            /// Id of the view model.
            ///
            public let id = UUID()

            var accessibilityId: String?

            /// Records to display.
            ///
            @Published public var records: [Record] = []

            /// Horizontal axis labels display config.
            ///
            @Published public var xConfig = AxisDisplayConfig(

                showGrid: true,
                labelCount: 6,
                limitConfig: .dynamic,
                scaleConfig: .dynamic,
                valueFormat: .int
            )

            /// Vertical axis labels display config.
            ///
            @Published public var yConfig = AxisDisplayConfig(

                showGrid: true,
                labelCount: 6,
                limitConfig: .dynamic,
                scaleConfig: .dynamic,
                valueFormat: .int
            )

            var yLabelFormatter: (Float) -> String {

                labelFormatter(with: yConfig.valueFormat)
            }

            var xLabelFormatter: (Float) -> String {

                labelFormatter(with: xConfig.valueFormat)
            }

            var yLabelVMs: [AxisLabelVM] {

                yLabels.enumerated().map { AxisLabelVM(value: $1, id: $0) }.reversed()
            }

            var xLabelVMs: [AxisLabelVM] {

                xLabels.enumerated().map { AxisLabelVM(value: $1, id: $0) }
            }

            var yGridLineVMs: [AxisGridVM] {

                guard yConfig.showGrid else {

                    return []
                }

                return (0..<yConfig.labelCount).map { index in

                    AxisGridVM(relativePosition: CGFloat(index) / CGFloat(yConfig.labelCount - 1), id: index)
                }
            }

            var xGridLineVMs: [AxisGridVM] {

                guard xConfig.showGrid else {

                    return []
                }

                return (0..<xConfig.labelCount).map { index in

                    AxisGridVM(relativePosition: CGFloat(index) / CGFloat(xConfig.labelCount - 1), id: index)
                }
            }

            var yAxisLimitValue: Float {

                switch yConfig.limitConfig {

                case .fixed(let value): return value
                case .dynamic:

                    return records.map {

                        switch $0.item {

                        case .grid(let grid): return max(grid.first.yCoordinate, grid.last.yCoordinate)

                        case .point(let point): return point.coordinates.yCoordinate

                        case .block(let block): return block.origin.yCoordinate

                        case .function(let function): return function.points.map { $0.yCoordinate }.max() ?? 1

                        }

                    }.max() ?? 1
                }
            }

            var xAxisLimitValue: Float {

                switch xConfig.limitConfig {

                case .fixed(let value): return value
                case .dynamic:

                    return records.map {

                        switch $0.item {

                        case .grid(let grid): return max(grid.first.xCoordinate, grid.last.xCoordinate)

                        case .point(let point): return point.coordinates.xCoordinate

                        case .block(let block): return block.origin.xCoordinate + block.width

                        case .function(let function): return function.points.map { $0.xCoordinate }.max() ?? 1

                        }

                    }.max() ?? 1
                }
            }

            init() {
            }

            // MARK: - Privates

            private static let defaultNumberFormatter: NumberFormatter = {

                let formatter = NumberFormatter()
                formatter.allowsFloats = false

                return formatter
            }()

            private static let defaultDateFormatter: DateFormatter = {

                let formatter = DateFormatter()
                formatter.dateFormat = "mm:ss"

                return formatter
            }()

            private var yLabels: [String] {

                guard yConfig.labelCount > 0 else {

                    return []
                }

                var result: [String] = [yLabelFormatter(0)]
                for index in 1..<yConfig.labelCount {

                    result.append(

                        yLabelFormatter((yAxisLimitValue / Float(yConfig.labelCount - 1)) * Float(index))
                    )
                }

                return result
            }

            private var xLabels: [String] {

                guard xConfig.labelCount > 0 else {

                    return []
                }

                var result: [String] = [xLabelFormatter(0)]
                for index in 1..<xConfig.labelCount {

                    result.append(

                        xLabelFormatter((xAxisLimitValue / Float(xConfig.labelCount - 1)) * Float(index))
                    )
                }

                return result
            }

            private func labelFormatter(with format: AxisDisplayConfig.ValueFormat) -> (Float) -> String {

                { value in

                    switch format {

                    case .int: return Self.defaultNumberFormatter.string(from: NSNumber(value: value))!

                    case .time: return Self.defaultDateFormatter.string(from: Date(timeIntervalSince1970: Double(value)))

                    case .custom(let formatter): return formatter(value)
                    }
                }
            }

        } // Interface

        // MARK: -

        public final class Impl: Interface {

            public init(configure: (Interface) -> Void = { _ in }) {

                super.init()

                configure(self)
            }

        } // Impl

    } // ViewModel

} // PlotView
