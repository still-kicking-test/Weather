# Weather

This app replicates much of the functionality of the UK Met Office weather app.

## Description

This is not intended to be a production-ready app. Rather, it is a showcase of the author's take on some of the more recent (and not so recent) iOS trends:
 
* SwiftUI
* Clean architecture
* Reactive approach using Swift's Combine
* Asynchronous functions using async/await
* CoreData
* Generic networking API layer (provided as an xcframework library downloaded using Swift Package Manager). Source code downloadable from the WeatherNetworking repo. 

The app does not have access to the UK Met Office services (unsurprisingly), and so uses public API services provided by OpenWeather. 

The latest version uses SwiftUI almost exclusively (the AppDelegate and some minor UIImage manipulation aside). The initial version (v1.0.0) implements an MVVM-C architecture, using mainly UIKit with a small amount SwiftUI.

## Getting Started

Note - app development has so far focussed on **Dark Mode** - and this is currently enforced.

### Weather Tab

* Displays summary forecasts at user-defined locations. The locations are managed on the Edit screen (and persisted in CoreData).
* Optionally displays a UK video forecast and a forecast for your current location. Optionals managed on the Edit screen.
* Tapping a summary forecast will display a full forecast for that location (tapping a particular day will initialise the display to that day).

#### Edit screen

* Accessed by tapping the Edit button on the Weather tab's navigation bar.
* Current location - if enabled, the forecast for your current location will be displayed on the Weather tab. The first time this is enabled, the app will ask for location permissions. Note that when run on an XCode simulator, the current location is read from that simulator (defined at Features->Location and defaulted to 'Apple' in Cupertino).
* UK video forecast - if enabled, a UK video forecast from the MetOffice will be displayed on the Weather tab. Ideally, today's video forecast would be displayed, but without access to the MetOffice servers, there is no easy way to determine its URL. An archived forecast is therefore displayed instead.
* Locations - a list of the currently defined locations to be shown on the Weather tab. These can be reordered by drag-and-drop (after a long-press). Due to a lack of an appropriate city-search API, the addition of locations is not yet implemented. However, a set of hard-coded test locations may be used instead - tapping the search box will present the user with the ability to reset to those locations.

#### Settings screen

* Accessed by tapping the Settings icon on the Weather tab's navigation bar.
* The functionality behind many of the settings is yet to be implemented.

### Maps Tab

Not yet implemented.

### Warnings Tab

Not yet implemented.

### Mocked API

If required, switch to a mocked API service through the device's Settings. Note that the current location's forecast is mocked as Apple's offices in Cupertino, so if running on an XCode simulator, please ensure that that simulator's location is set to 'Apple', otherwise a JSON error will occur as the correct resource file will not be found.

## Acknowledgements

* [OpenWeather](https://openweathermap.org)
