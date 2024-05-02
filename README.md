# Weather

This app replicates much of the functionality of the UK Met Office weather app.

## Description

This is not intended to be a production-ready app. Rather, it is a showcase of the author's take on some of the more recent (and not so recent!) iOS trends:
 
* SwiftUI
* Clean architecture
* Reactive approach using Swift's Combine
* Asynchronous functions using async/await
* CoreData
* Generic networking API layer (provided as an xcframework library downloaded using Swift Package Manager). Source code downloadable from the WeatherNetworking repo. 

The app does not have access to the UK Met Office services (unsurprisingly), and so uses public API services provided by OpenWeather. 

Note that the latest version uses almost exclusively SwiftUI (the AppDelegate and some minor UIImage manipulation aside), the initial version (v1.0.0) concentrates instead on UIKit and an MVVM-C architecture.

## Getting Started

Note - app development has so far focussed on **Dark Mode** - and this is currently enforced (though admittedly the OpenWeather icons are not particularly effective in Dark Mode).

### Weather Tab

* Displays summary forecasts at defined locations - locations are managed on the Edit screen (and persisted in CoreData).
* Optionally displays a forecast for your current location and a UK video forecast. Optionals managed on the Edit screen.
* Tapping a summary forecast will display a full forecast for that location.

### Edit screen

* Accessed by tapping the Edit button on the Weather tab.
* Current location - if enabled, the forecast for your current location will be displayed on the Weather tab. The first time this is enabled, the app will ask for location permissions.
* UK video forecast - if enabled, a UK video forecast from the MetOffice will be displayed on the Weather tab. Ideally, today's video forecast would be displayed, but without access to the MetOffice servers, there is no easy way to determine its URL. An archived forecast is therefore displayed instead.
* Locations - a list of the currently defined locations to be shown on the Weather tab. These can be reordered by drag-and-drop (after a long-press). The addition of locations is in not yet implemented, though a set of hard-coded test locations may be used instead - tapping the search box will present the user with the ability to reset to those locations.

### Settings screen

The functionality behind many of the settings on this screen is not yet implemented.

### Maps Tab

Not yet implemented.

### Warnings Tab

Not yet implemented.

### Mocked API

If required, switch to a mocked API service through the device's Settings. Note that the current location is mocked as Apple's offices in Cupertino, so please ensure your Simulator's location is set to 'Apple', otherwise a JSON error will occur as the correct resource file will not be found.

## Acknowledgements

* [OpenWeather](https://openweathermap.org)
