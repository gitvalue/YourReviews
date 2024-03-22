# YourReviews
A tiny application that performs AppStore reviews feed fetch

# Features

- Dark and light theme support (based on system setting)
- Zero external dependencies
- Swift 5
- Combine
- MVVM
- UIKit
- XCTest

### Installing

Just clone this repo and open `YourReviews/YourReviews.xcodeproj`, then run the application.

```bash
git clone git@github.com:gitvalue/YourReviews.git
xed YourReviews/YourReviews/YourReviews.xcodeproj
```

## Architecture

Here you will see what YourReviews is built of.

### Modules

`YourReviews` project consists of 3 modules:
- App
- Networking

### Networking

This module is the basement of the `YourReviews` app and represents the network layer. It allows us to make requests using plain `Codable` data structures and handle the results the same manner.

### App

Literally the main target. It consists of three screens: `ReviewsFeedViewController`, `ReviewDetailsViewController` and `FiltersViewController`, designed using `MVVM` architectual pattern. I believe it's the best option for building an iOS application which roadmap is not transparent. 

Main task of any architecture is to control complexity, i.e. amount of effort should be adequate comparing to the requested changes. And any iOS application in a nutshell is just a set of screens hence the nature of this screens dictates the architecture. In our case, we have just three screens:
1. Feed
2. Details screen
3. Filters

Details and Filters screens are passive, meaning they don't request any data by itself, just wait until something will _push data_ into it.

Feed screen, on the other hand is dynamic, meaning it _pulls data_ it needs to display.

Most popular alternatives, like MVP and VIPER are designed to _push_ data into view, MVVM — to let view _pull_ data from its viewModel. 

And that, I believe, makes MVVM best option in our case, because lists are more than common in iOS application and most certainly are going to come up once application will start to grow. And if we take a look at the way lists can be built it iOS application:
1. UIKit (Regular `UITable/UICollectionView`) - pull data model
2. UIKit (Modern `UICollectionView`) — push data model
3. SwiftUI - pull data model

We see that MVVM is perfect for 2 out of 3 options (1 and 3), and just fine for the option 2, while MVP and VIPER really work well only with option 2.

## Versioning

This repo do not use any versioning system because I have no plans of maintaining the application in the future

## Troubleshooting

For any questions please fell free to contact [Dmitry Volosach](dmitry.volosach@gmail.com).

## Further steps

- Add more filters
- Upgrade to current version of the API
- Add more info on details screen
- Add empty feed placeholder

## Authors

* **Dmitry Volosach** - *Initial work* - dmitry.volosach@gmail.com