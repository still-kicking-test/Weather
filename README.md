# Weather

This app replicates much of the functionality of the UK Met Office weather app.

## Description

This is not intended to be a production-ready app. It is simply a showcase of the author's take on some of the more recent (and not so recent!) architectural trends:
 
* MVVM-C
* Reactive approach using Swift's Combine
* Asynchronous functions using async/await
* Generic networking API layer
* SwiftUI
* CoreData

The app does not have access to the UK Met Office services (unsurprisingly), and so uses public API services provided by OpenWeather. 

## Getting Started

Note - app development has so far focussed on **Dark Mode** - switch to this for an optimal UI.

### Weather Tab

* The Weather tab presents summary forecasts at defined locations - these locations are stored in CoreData and are managed by tapping the Edit button.
* Tapping a summary forecast will display a full forecast for that location - that full forecast screen is WIP.
* The Settings screen is written in SwiftUI, and currently WIP.

### Edit locations

* Current location - if enabled, the forecast for your current location will be shown on the Weather tab. The first time this is enabled, the app will ask for location permissions.
* UK video forecast -  if enabled, this would ideally show a video forecast, but this is not yet implemented. When it is, it will probably show a video of the author describing the app.
* Locations - a list of the currently defined locations to be shown on the Weather tab. These can be reordered by drag-and-drop (after a long-press).

The addition and deletion of a location is not yet implemented - hence the set of hard-coded dummy locations.

### Maps Tab

Not yet implemented - contains dummy functionality

### Warnings Tab

Not yet implemented - contains dummy functionality

## Acknowledgments

* [OpenWeather](https://openweathermap.org)
