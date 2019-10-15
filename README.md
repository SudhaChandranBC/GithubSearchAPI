# GithubSearchAPI
Swift implementation of Github Repository Search API.

## Installation

GithubSearchAPI is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'GithubSearchAPI'
```

### GithubSearch API

#### Search all repositories with matching query and filtered by organisation:

```swift
GithubSearchAPI().search(matching: "android", filterBy: "rakutentech") { (result) in
    switch result {
        case .success(let repositories):
            print(repositories)
            //Handle Success
        case .failure( _):
            //Handle Failure
            break
    }
}
```

## Requirements

* Xcode 10 or later
* iOS 9.0 or later
* macOS 10.12 or later
* Swift 5 compatible


## Author

Chandran Sudha, sudhachandran1bc@gmail.com


## License

GithubSearch API is available under the MIT license. See the LICENSE file for more info.
