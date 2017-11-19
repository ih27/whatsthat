#  WhatsThat by Ismayil Hasanov

Description: The app lets users discover more information about things they see.

## Functional requirements:
1) ~~Display a menu screen upon launching the app that allows the user to snap/select a photo or view previously identified favorites~~
2) ~~Allow the user to snap a photo using the camera, or choose an existing photo from the Camera Roll, and identify what is in the photo~~
3) ~~Display the photo, along with with a list of results of the identification~~
4) ~~Upon the user selecting an identification, display a detailed description~~
5) ~~From the description screen, allow the user to tap a button to display the Wikipedia page for more information~~
6) From the description screen, allow the user to tap a button to search twitter for the identification
7) Allow the user to scroll through a Twitter results screen
8) Allow the user to favorite/unfavorite an identification from the description screen
9) ~~Allow the user to share an identification/description from the description screen~~
10) Allow the user to view a list of favorited identifications, tapping an identification will display a description screen (just like the prior requirement)
11) Never crash or leave user in a bad state! If something goes wrong, present a helpful alert to the user
---
## Implementation requirements:
* Follow architecture guidelines [here](https://docs.google.com/drawings/d/1Kc6rPKa9k94aPkwGJZHOgSF776gEFbRDpDvEQeVXceU/edit?usp=sharing)
* ~~Use Swift. No Objective-C!~~
* ~~Follow Coding Guidelines at bottom~~
* ~~Use a Storyboard, Interface Builder, and AutoLayout~~
* ~~You should have no AutoLayout constraint warnings or errors~~
* ~~Your initial view controller should be a UINavigationViewController~~
* ~~Utilize UIImagePickerController to allow the user to snap a photo or choose one from his or her Camera Roll~~
* ~~Handle camera / photo library runtime permissions properly~~
* ~~Use the Google Vision and Wikipedia API’s (JSON, not XML)~~
* ~~Swift 4’s Codeable feature should be used to convert JSON response into your model objects~~
* ~~Retrieve and parse photo identification data from the [Google Vision API](https://cloud.google.com/vision/). You can use it for free up to 1K requests/month)~~
* ~~Retrieve and parse Wikipedia data from the [Wikipedia API](https://www.mediawiki.org/wiki/API:Main_page) (hint: you can just make a GET request to a URL like [this](https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles=iPhone), no key required)~~
* ~~Both Google Vision and Wikipedia data should be downloaded on a background thread using a black box “manager class”~~
* ~~The result should be array of model objects (e.g. GoogleVisionResult objects or a WikipediaResult object), it should not return a JSON object~~
* ~~A [SafariViewController](https://www.hackingwithswift.com/read/32/3/how-to-use-sfsafariviewcontroller-to-browse-a-web-page) should be used to load the wikipedia page (example [link](https://en.wikipedia.org/?curid=16161443))~~
* ~~Any list in the app (except the Tweet list) should be displayed using a UITableView~~
* Twitter’s [TwitterKit](https://dev.twitter.com/twitterkit/ios/overview) and its “Search Timeline” feature should be used to interact with Twitter and display Tweets (using TWTRTimelineViewController)
* Include the TwitterKit library using CocoaPods
* Persist favorited identifications/descriptions using UserDefaults
* ~~Share functionality should be implemented using a UIActivityViewController~~
* ~~Utilize “black box” classes for encapsulating functionality - (e.g. GoogleVisionAPIManager.swift, PersistanceManager.swift, etc..)~~
* ~~“Black box” classes should communicate with UIViewControllers using Protocols~~
* Support portrait and landscape mode (UI components should not be cut off if user switches to landscape)
* Don't forget to to include an app icon
---
## Coding Guidelines:
* ~~Github must be used as your source control commits should be happening incrementally leading up until the deadline~~
* ~~Don’t do a big commit right at the very end~~
* ~~Comment your code~~
* ~~Utilize separate classes for chunks of functionality (e.g. GoogleVisionAPIManager.swift) this will avoid crowding your UIViewController classes~~
* ~~Write clean code!~~
* Don’t turn in code with random lines commented out (e.g. // let test = “123”)
* ~~Adhere to basic Swift coding standards~~
* ~~Capitalize first letter of class names (e.g. MyClass.swift)~~
* Correct use of Optionals and null handling (I don’t want to see “!” anywhere!)
* ~~Correct use of let and var~~
* ~~Camel case variable names (e.g. let firstName= “jared”)~~
* ~~No underscores anywhere~~
