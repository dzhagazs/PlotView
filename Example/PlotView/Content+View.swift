//
//  Content+View.swift
//  PlotView_Example
//
//  Created by dzhagaz on 27.04.2023.
//

import SwiftUI

import PlotView

extension Content {

    struct View: SwiftUI.View {

        @ObservedObject var viewModel: Content.ViewModel.Interface

        var body: some SwiftUI.View {

            TabView {

                ForEach(viewModel.pages) { page in

                    VStack {

                        Text(page.title)

                        ForEach(page.plotVMs) {

                            PlotView.View(viewModel: $0)
                        }
                    }

                    .tabItem {

                        Image(systemName: page.icon)
                    }
                }

                .padding()
            }
        }

    } // Content.View

} // Content

struct Content_View_Previews: PreviewProvider {

    static var previews: some View {

        Content.View(viewModel: Content.ViewModel.Factory.createPreviewVM())
    }

} // ContentView_Previews
