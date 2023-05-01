//
//  PlotViewApp.swift
//  PlotView_Example
//
//  Created by dzhagaz on 27.04.2023.
//

import SwiftUI

@main
struct PlotViewApp: App {

    var body: some Scene {

        WindowGroup {

            Content.View(viewModel: Content.ViewModel.Factory.createPreviewVM())
        }
    }

} // PlotViewApp
