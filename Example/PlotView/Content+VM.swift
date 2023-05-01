//
//  Content+VM.swift
//  PlotView_Example
//
//  Created by dzhagaz on 27.04.2023.
//

import Combine
import SwiftUI

import PlotView

extension Content {

    struct ViewModel {

        struct Factory {

            static func createPreviewVM() -> Interface {

                let pointColor = Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
                var points: [Record] = []
                var shifted = false
                for i in 0 ..< 10 {

                    for j in 0 ..< 10 {

                        points.append(.init(item: .point(.init(

                            coordinates: .init(

                                xCoordinate: Float(j) * 50 + (shifted ? 125 : 100),
                                yCoordinate: Float(i) * 50 + 100
                            ),
                            color: pointColor
                        ))))
                    }
                    shifted.toggle()
                }

                let blocks: [Record] = [

                    .init(

                        item: .block(.init(

                            width: 30,
                            origin: .init(xCoordinate: 20, yCoordinate: 60),
                            toColor: Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)),
                            fromColor: Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
                        ))
                    ),
                    .init(

                        item: .block(.init(

                            width: 40,
                            origin: .init(xCoordinate: 70, yCoordinate: 40),
                            toColor: Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
                            fromColor: Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
                        ))
                    ),
                    .init(

                        item: .block(.init(

                            width: 40,
                            origin: .init(xCoordinate: 130, yCoordinate: 50),
                            toColor: Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)),
                            fromColor: Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
                        ))
                    ),
                    .init(

                        item: .block(.init(

                            width: 60,
                            origin: .init(xCoordinate: 210, yCoordinate: 70),
                            toColor: nil,
                            fromColor: nil
                        ))
                    ),
                ]

                return .init(pages: [

                    .init(

                        icon: "square",
                        title: "Block",
                        plotVMs: [

                        PlotView.ViewModel.Impl {

                            $0.records = blocks
                            $0.xConfig.limitConfig = .fixed(value: 300)
                            $0.yConfig.limitConfig = .fixed(value: 100)
                            $0.yConfig.labelCount = 6
                            $0.xConfig.labelCount = 7
                            $0.xConfig.showGrid = false
                        },
                        PlotView.ViewModel.Impl {

                            $0.records = blocks
                            $0.xConfig.limitConfig = .fixed(value: 300)
                            $0.yConfig.limitConfig = .fixed(value: 100)
                            $0.xConfig.labelCount = 0
                            $0.yConfig.labelCount = 0
                            $0.yConfig.showGrid = false
                        },
                        PlotView.ViewModel.Impl {

                            $0.records = blocks
                            $0.xConfig.scaleConfig = .fixed(value: 3)
                            $0.xConfig.limitConfig = .fixed(value: 300)
                            $0.yConfig.limitConfig = .fixed(value: 100)
                            $0.yConfig.labelCount = 6
                            $0.xConfig.labelCount = 7
                            $0.xConfig.showGrid = false
                        },
                        PlotView.ViewModel.Impl {

                            $0.records = blocks
                            $0.yConfig.scaleConfig = .fixed(value: 3)
                            $0.xConfig.limitConfig = .fixed(value: 300)
                            $0.yConfig.limitConfig = .fixed(value: 100)
                            $0.yConfig.labelCount = 6
                            $0.xConfig.labelCount = 7
                            $0.yConfig.showGrid = false
                        },
                    ]),

                    .init(

                        icon: "alternatingcurrent",
                        title: "Function",
                        plotVMs: [

                        PlotView.ViewModel.Impl {

                            $0.records = [cosFuncRecord(verticalOffset: 60)] + [sinFuncRecord(verticalOffset: 30)]
                            $0.yConfig.limitConfig = .fixed(value: 100)
                        },
                        PlotView.ViewModel.Impl {

                            $0.records = [

                                powFuncRecord(power: 2, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)),
                                .init(item: .function(.init(points: [

                                    .init(xCoordinate: 27, yCoordinate: 0),
                                    .init(xCoordinate: 120, yCoordinate: 10000),

                                ], color: Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))))),
                            ]

                        },
                        PlotView.ViewModel.Impl {

                            $0.records = [.init(

                                item: .function(.init(

                                    points: [

                                        .init(xCoordinate: 0, yCoordinate: 2),
                                        .init(xCoordinate: 1, yCoordinate: 4),
                                        .init(xCoordinate: 2, yCoordinate: 5),
                                        .init(xCoordinate: 3, yCoordinate: 4),
                                        .init(xCoordinate: 4, yCoordinate: 8),
                                        .init(xCoordinate: 5, yCoordinate: 10),
                                        .init(xCoordinate: 6, yCoordinate: 5),
                                        .init(xCoordinate: 7, yCoordinate: 14),
                                        .init(xCoordinate: 8, yCoordinate: 22),
                                        .init(xCoordinate: 9, yCoordinate: 36),
                                        .init(xCoordinate: 10, yCoordinate: 17),
                                        .init(xCoordinate: 11, yCoordinate: 12),
                                        .init(xCoordinate: 12, yCoordinate: 25),
                                        .init(xCoordinate: 13, yCoordinate: 26),
                                        .init(xCoordinate: 14, yCoordinate: 28),
                                        .init(xCoordinate: 15, yCoordinate: 15),
                                        .init(xCoordinate: 16, yCoordinate: 18),
                                        .init(xCoordinate: 17, yCoordinate: 19),
                                        .init(xCoordinate: 18, yCoordinate: 21),
                                        .init(xCoordinate: 19, yCoordinate: 28),
                                        .init(xCoordinate: 20, yCoordinate: 36),
                                    ],
                                color: nil)))]
                        }
                    ]),

                    .init(

                        icon: "smallcircle.filled.circle",
                        title: "Point",
                        plotVMs: [

                        PlotView.ViewModel.Impl {

                            $0.records = points
                            $0.xConfig.limitConfig = .fixed(value: 700)
                            $0.yConfig.limitConfig = .fixed(value: 700)
                            $0.xConfig.showGrid = false
                            $0.yConfig.showGrid = false
                        },
                    ]),

                    .init(

                        icon: "grid",
                        title: "Grid",
                        plotVMs: [

                        PlotView.ViewModel.Impl {

                            $0.records = [

                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 0, yCoordinate: 150),
                                    first: .init(xCoordinate: 100, yCoordinate: 150),
                                    pattern: .lineDot,
                                    color: Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
                                ))),
                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 200, yCoordinate: 150),
                                    first: .init(xCoordinate: 300, yCoordinate: 150),
                                    pattern: .lineDot,
                                    color: Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
                                ))),
                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 150, yCoordinate: 100),
                                    first: .init(xCoordinate: 150, yCoordinate: 0),
                                    pattern: .lineDot,
                                    color: Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
                                ))),
                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 150, yCoordinate: 200),
                                    first: .init(xCoordinate: 150, yCoordinate: 300),
                                    pattern: .lineDot,
                                    color: Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
                                ))),
                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 150, yCoordinate: 200),
                                    first: .init(xCoordinate: 100, yCoordinate: 150),
                                    pattern: .line,
                                    color: Color(#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
                                ))),
                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 100, yCoordinate: 150),
                                    first: .init(xCoordinate: 150, yCoordinate: 100),
                                    pattern: .line,
                                    color: Color(#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
                                ))),
                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 200, yCoordinate: 150),
                                    first: .init(xCoordinate: 150, yCoordinate: 100),
                                    pattern: .line,
                                    color: Color(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))
                                ))),
                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 200, yCoordinate: 150),
                                    first: .init(xCoordinate: 150, yCoordinate: 200),
                                    pattern: .line,
                                    color: Color(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))
                                ))),
                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 0, yCoordinate: 0),
                                    first: .init(xCoordinate: 300, yCoordinate: 300),
                                    pattern: .dot,
                                    color: Color(#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1))
                                ))),
                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 0, yCoordinate: 300),
                                    first: .init(xCoordinate: 300, yCoordinate: 0),
                                    pattern: .dot,
                                    color: Color(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1))
                                ))),
                            ]
                            $0.xConfig.labelCount = 7
                            $0.yConfig.labelCount = 7
                            $0.xConfig.showGrid = false
                            $0.yConfig.showGrid = false
                            $0.xConfig.limitConfig = .fixed(value: 300)
                            $0.yConfig.limitConfig = .fixed(value: 300)
                        },
                    ]),

                    .init(

                        icon: "infinity",
                        title: "All together",
                        plotVMs: [

                        PlotView.ViewModel.Impl {

                            $0.records = [

                                squareFuncRecord(),
                                .init(item: .block(.init(

                                    width: 20,
                                    origin: .init(

                                        xCoordinate: 5,
                                        yCoordinate: 250
                                    ),
                                    toColor: Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
                                    fromColor: Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
                                ))),
                                .init(item: .block(.init(

                                    width: 20,
                                    origin: .init(

                                        xCoordinate: 75,
                                        yCoordinate: 250
                                    ),
                                    toColor: Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
                                    fromColor: Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
                                ))),
                                .init(item: .block(.init(

                                    width: 20,
                                    origin: .init(

                                        xCoordinate: 20,
                                        yCoordinate: 750
                                    ),
                                    toColor: Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),
                                    fromColor: Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
                                ))),
                                .init(item: .block(.init(

                                    width: 20,
                                    origin: .init(

                                        xCoordinate: 60,
                                        yCoordinate: 750
                                    ),
                                    toColor: Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),
                                    fromColor: Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
                                ))),
                                .init(item: .block(.init(

                                    width: 20,
                                    origin: .init(

                                        xCoordinate: 40,
                                        yCoordinate: 1500
                                    ),
                                    toColor: Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)),
                                    fromColor: Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                                ))),
                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 0, yCoordinate: 2750),
                                    first: .init(xCoordinate: 100, yCoordinate: 2750),
                                    pattern: .lineDot,
                                    color: nil
                                ))),
                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 0, yCoordinate: 2100),
                                    first: .init(xCoordinate: 100, yCoordinate: 2100),
                                    pattern: .lineDot,
                                    color: nil
                                ))),
                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 30, yCoordinate: 0),
                                    first: .init(xCoordinate: 30, yCoordinate: 3000),
                                    pattern: .line,
                                    color: nil
                                ))),
                                .init(item: .grid(.init(

                                    last: .init(xCoordinate: 70, yCoordinate: 0),
                                    first: .init(xCoordinate: 70, yCoordinate: 3000),
                                    pattern: .line,
                                    color: nil
                                ))),
                                .init(item: .point(.init(

                                    coordinates: .init(

                                        xCoordinate: 40,
                                        yCoordinate: 2450),
                                    color: Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                                ))),
                                .init(item: .point(.init(

                                    coordinates: .init(

                                        xCoordinate: 45,
                                        yCoordinate: 2550),
                                    color: Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                                ))),
                                .init(item: .point(.init(

                                    coordinates: .init(

                                        xCoordinate: 49,
                                        yCoordinate: 2580),
                                    color: Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                                ))),
                                .init(item: .point(.init(

                                    coordinates: .init(

                                        xCoordinate: 58,
                                        yCoordinate: 2610),
                                    color: Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                                ))),
                                .init(item: .point(.init(

                                    coordinates: .init(

                                        xCoordinate: 43,
                                        yCoordinate: 2300),
                                    color: Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
                                ))),
                                .init(item: .point(.init(

                                    coordinates: .init(

                                        xCoordinate: 49,
                                        yCoordinate: 2400),
                                    color: Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
                                ))),
                                .init(item: .point(.init(

                                    coordinates: .init(

                                        xCoordinate: 53,
                                        yCoordinate: 2320),
                                    color: Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
                                ))),
                            ]
                            $0.xConfig.limitConfig = .fixed(value: 100)
                            $0.yConfig.limitConfig = .fixed(value: 3000)
                            $0.xConfig.showGrid = false
                            $0.yConfig.showGrid = false
                            $0.xConfig.labelCount = 6
                            $0.yConfig.labelCount = 7
                        },
                    ]),

                ])
            }

            // MARK: - Privates

            typealias Record = PlotView.ViewModel.Record

            static private func cosFuncRecord(verticalOffset: Float) -> Record {

                var points: [Record.Item.Coordinates] = []
                let color = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)

                let step: Float = 0.1
                for x in 0 ..< 200 {

                    points.append(

                        .init(

                            xCoordinate: Float(x * 9),
                            yCoordinate: (cos(Float(x) * step) * 20) + verticalOffset
                        ))
                }

                return .init(item: .function(.init(points: points, color: Color(color))))
            }

            static private func sinFuncRecord(verticalOffset: Float) -> Record {

                var points: [Record.Item.Coordinates] = []
                let color = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)

                let step: Float = 0.1
                for x in 0 ..< 200 {

                    points.append(

                        .init(

                            xCoordinate: Float(x * 9),
                            yCoordinate: (sin(Float(x) * step) * 20) + verticalOffset
                        ))
                }

                return .init(item: .function(.init(points: points, color: Color(color))))
            }

            static private func powFuncRecord(power: Float, color: UIColor) -> Record {

                var points: [Record.Item.Coordinates] = []

                for x in 0 ..< 100 {

                    points.append(

                        .init(

                            xCoordinate: Float(x),
                            yCoordinate: pow(Float(x), power)
                        ))
                }

                return .init(item: .function(.init(points: points, color: Color(color))))
            }

            static private func squareFuncRecord() -> Record {

                var points: [Record.Item.Coordinates] = []
                let max = 50 * 50
                let color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

                for x in -50 ..< 50 {

                    points.append(

                        .init(

                            xCoordinate: Float(x) + 50,
                            yCoordinate: Float(max - x * x)
                        ))
                }

                return .init(item: .function(.init(points: points, color: Color(color))))
            }

        } // Factory

        class Interface: ObservableObject {

            struct Page: Identifiable {

                let id = UUID()

                let icon: String
                let title: String
                let plotVMs: [PlotView.ViewModel.Interface]

            } // Page

            @Published var pages: [Page]

            init(pages: [Page]) {

                self.pages = pages
            }

        } // Interface

    } // ViewModel

} // Content
