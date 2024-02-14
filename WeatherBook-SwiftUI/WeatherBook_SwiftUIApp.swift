//
//  WeatherBook_SwiftUIApp.swift
//  WeatherBook-SwiftUI
//
//  Created by Sravanthi Chinthireddy on 13/02/24.
//

import SwiftUI

@main
struct WeatherBook_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(cityName: "", climateImageName: "-", temperatureValue: "-")
        }
    }
}
