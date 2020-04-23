# passwall-mobile

PassWall Mobile is a mobile client for PassWall API written with Flutter.

![Flutter CI](https://github.com/pass-wall/passwall-mobile/workflows/Flutter%20CI/badge.svg?branch=master)
[![Made-with-Flutter](https://img.shields.io/badge/Made%20with-Flutter-5fc9f8.svg)](https://flutter.dev/)
[![Made-with-Dart](https://img.shields.io/badge/Made%20with-Dart-13589c.svg)](https://dart.dev/)

## Getting Started

1. First, clone the [server app](https://github.com/pass-wall/passwall-server) and buld it.

1. Then, [Install](https://flutter.dev/docs/get-started/install) Flutter, clone the repository  and let’s Rock!

1. Do not forget the  `flutter pub get` 

> For help getting started with Flutter, view their [online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.

## Hello Contributers

1. Don't send too much commit at once. It will be easier for us to do a code review.

1. Be sure to take a look at the second branch. The version I am working on is there.

1. First try to fix `//TODO:`s in the code.

1. Then you can contribute to the development by following the mile stones.

1. Don't mess with the user interface. The design guide has not been released yet.

> When you want to connect to the localhost server with the Android emulator, you connect to the emulator's localhost server and you get an error. Instead, try connecting to the [Heroku Demo server](https://passwall-server.herokuapp.com).

## Mile Stones

- [x] v0.1.0 Waking Up
	- [x] Authentication
		- [x] Login
		- [x] Check token. If valid, redirect to main screen
		- [x] Logout
	- [x] Get all credentials *(Url or Title, Username and Password)* and list them on the main screen
	- [x] Search in credentials
	- [x] Copy password
- [x] v0.2.0 Growing Up
	- [x] Pull to refresh in main screen
	- [x] Swipe to delete credential
	- [x] Update credential
	- [x] Create new credential
	- [x] Generate password
	- [ ] ~~Order the list~~ *postponed*
	- [x] Keeping logs
- [x] v0.3.0 Sharing
	- [x] Export credential and share
	- [x] Import credential
	    - [x] With file pick
	    - [ ] ~~Share Intent~~ *postponed*
- [ ] v0.4.0 Polishing
	- [x] Logo and Name
	- [x] UI customise *Not bad for now i guess*
	- [x] About page  
	- [ ] Re-design for large screens
- [ ] v0.5.0 Securing
	- [ ] Biometric Auth
	- [ ] iOS Blur Screen when the app is in the background
- [ ] v0.6.0 Powering Up
	- [ ] Dark Mode
	- [x] Localization
- [ ] V1.0.0 Compile’n release
    - [x] AndroidOS
    - [ ] MacOS
    - [ ] Windows
    - [ ] Browser
    - [ ] ~~iOS~~

## Some Screen Shots

### Screens

<table>
    <tr>
        <td><img src="screenshots/login.png" alt="Login Screen"/></td>
        <td><img src="screenshots/main.png" alt="Main Screen"/></td>
        <td><img src="screenshots/detail.png" alt="Detail Screen"/></td>
        <td><img src="screenshots/about.png" alt="About Screen"/></td>
    </tr>
    <tr>
        <td>Login Screen:point_up:</td>
        <td>Main Screen:point_up:</td>
        <td>Detail Screen:point_up:</td>
        <td>About Screen:point_up:</td>
    </tr>
</table>

### Actions

<table>
    <tr>
        <td><img src="screenshots/mainAction.png" alt="Main Action"/></td>
        <td><img src="screenshots/tileAction.png" alt="Tile Action"/></td>
        <td><img src="screenshots/createNew.png" alt="Create New"/></td>
    </tr>
    <tr>
        <td>Main Action:point_up:</td>
        <td>Tile Action:point_up:</td>
        <td>Create New:point_up:</td>
    </tr>
</table>

### Share

<table>
    <tr>
        <td><img src="screenshots/export.png" alt="Export"/></td>
        <td><img src="screenshots/import.png" alt="Import"/></td>
        <td><img src="screenshots/share.png" alt="Share"/></td>
  </tr>
  <tr>
        <td>Export:point_up:</td>
        <td>Import:point_up:</td>
        <td>Share:point_up:</td>
  </tr>
</table>


