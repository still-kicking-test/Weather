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

* Displays summary forecasts at defined locations - these are managed on the Edit screen (and persisted in CoreData).
* Optionally displays a forecast for your current location and a UK video forecast. Optional display managed on the Edit screen.
* Tapping a summary forecast will display a full forecast for that location - currently in WIP.
* The Settings screen is written in SwiftUI - links from that screen are currently in WIP.

### Edit screen

* Access by tapping the Edit button on the Weather tab.
* Current location - if enabled, the forecast for your current location will be shown on the Weather tab. The first time this is enabled, the app will ask for location permissions.
* UK video forecast -  if enabled, shows a UK video forecast from the MetOffice. Ideally today's video forecast would be displayed, but without access to the MetOffice servers, there is no easy way to determine its URL. An archived forecast from the 4th October 2023 is therefore displayed instead.
* Locations - a list of the currently defined locations to be shown on the Weather tab. These can be reordered by drag-and-drop (after a long-press).

The addition and deletion of locations is in WIP - hence the set of hard-coded example locations.

### Maps Tab

WIP - contains dummy functionality

### Warnings Tab

WIP - contains dummy functionality

## Acknowledgments

* [OpenWeather](https://openweathermap.org)
