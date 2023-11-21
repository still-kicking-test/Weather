# Weather

This app replicates much of the functionality of the UK Met Office weather app.

## Description

This is not intended to be a production-ready app. It is simply a showcase of the author's take on some of the more recent (and not so recent!) architectural trends:
 
* SwiftUI
* Reactive approach using Swift's Combine
* Asynchronous functions using async/await
* MVVM-C
* CoreData
* Generic networking API layer (provided as an xcframework library downloaded using Swift Package Manager). Source code downloadable from the WeatherNetworking repo. 

The app does not have access to the UK Met Office services (unsurprisingly), and so uses public API services provided by OpenWeather. 

## Getting Started

Note - app development has so far focussed on **Dark Mode** - switch to this for an optimal UI (though admittedly the OpenWeather icons are not particularly effective in Dark Mode).

### Weather Tab

* Displays summary forecasts at defined locations - locations are managed on the Edit screen (and persisted in CoreData). Written with UIKit.
* Optionally displays a forecast for your current location and a UK video forecast. Optionals managed on the Edit screen. Written with UIKit.
* Tapping a summary forecast will display a full forecast for that location. Written in SwiftUI.
* The Settings screen is currently in WIP. Written in SwiftUI.

### Edit screen

* Access by tapping the Edit button on the Weather tab.
* Current location - if enabled, the forecast for your current location will be shown on the Weather tab. The first time this is enabled, the app will ask for location permissions.
* UK video forecast - if enabled, shows a UK video forecast from the MetOffice. Ideally today's video forecast would be displayed, but without access to the MetOffice servers, there is no easy way to determine its URL. An archived forecast is therefore displayed instead.
* Locations - a list of the currently defined locations to be shown on the Weather tab. These can be reordered by drag-and-drop (after a long-press). The addition of locations is in WIP, though a set of hard-coded test locations may be used instead - tapping the search box will present the user with ability to reset to those locations.


### Maps Tab

WIP

### Warnings Tab

WIP

## Acknowledgments

* [OpenWeather](https://openweathermap.org)
