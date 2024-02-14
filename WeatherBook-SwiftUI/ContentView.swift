//
//  ContentView.swift
//  WeatherBook-SwiftUI
//
//  Created by Sravanthi Chinthireddy on 13/02/24.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

class LocationViewModel: NSObject, ObservableObject {
    private var locationManager: CLLocationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
//        self.locationManager = locationManager
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
//    init(locationManager: CLLocationManager = CLLocationManager()) {
//        super.init()
//        locationManager.delegate = self
//        self.locationManager = locationManager
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            self.location = location
            print(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

struct ContentView: View {
    @State var cityName: String
    @State var climateImageName: String
    @State var temperatureValue: String
    
    @ObservedObject var manager = WeatherManager()
    @StateObject var locationViewModel = LocationViewModel()
//    var delegate: WeatherManagerDelegate = Self.self as! WeatherManagerDelegate
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .aspectRatio(1/2, contentMode: .fill)
                .ignoresSafeArea(.all)
                
            VStack {
                HStack {
                    LocationButton(.currentLocation) {
                        locationViewModel.requestLocation()
                        if let location = locationViewModel.location {
                            manager.fetchWeather(withLatitude: location.coordinate.latitude,
                                                 andLogitude: location.coordinate.longitude)
                        }
                    }
                    .font(.footnote)
                    
                    TextField(text: $cityName, prompt: Text("Search City here")) {
                        
                    }
                    .onSubmit {
                        callAPI()
                    }
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .border(.secondary)
                    .textFieldStyle(.roundedBorder)
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.large)
                    })
                    
                }
                .padding(.bottom, 20)
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 15, content: {
                        Image(systemName: manager.imageName)
                            .resizable()
                            .frame(width: 100, height: 100)
                        HStack {
                            Text(manager.tempString)
                                .font(.largeTitle)
                            .fontWeight(.bold)
                            Text(" °C")
                                .font(.title2)
                                .fontWeight(.regular)
                        }
                        
                        Text("\(manager.city)")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .fontWeight(.medium)
                    })
                    .padding(.trailing, 20)
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear(perform: {
            locationViewModel.requestLocation()
        })
    }
    
    func callAPI() {
        print(cityName)
        manager.fetchWeather(cityName: cityName)
    }
}

#Preview {
    ContentView(cityName: "", climateImageName: "-", temperatureValue: "-")
}
