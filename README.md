# FlicPic

An iOS app made in Swift as an inverview, made for HoC

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development.

### Prerequisites

Edit `FPCore/FPCore/Config.swift` and put in the correct values for your Flickr API. Replace `<API KEY>` and `<API SECRET>` with the corret once found in [Flickr App Garden](https://www.flickr.com/services/).

```
struct FPConfig {
    static let apiKey = "<API KEY>"
    static let apiSecret = "<API SECRET>"
}

```
You also need to change the URL which the user should be redirected to, for being authenticated with Flickr. This URL you'll find in [Flickr App Garden](https://www.flickr.com/services/), "Edit Authentication Flow". 

### Installing

Before you cen run this project you need to download all git submobules by running this command in your terminal:

```
git submodule update
```


## Built With

* [PKHUD](https://github.com/pkluz/PKHUD) - UI Feedback views

## Authors

* **Simon Jensen** - *Initial work* - [Askilada](https://github.com/Askilada)



