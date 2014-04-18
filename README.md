localsocial-iOS-SDK-demo
========================

An iOS demo app features the LocalSocial iOS SDK.

## What is LocalSocial? ##

LocalSocial is an In-Store Engagement Platform for retailers, venue owners and others to add in-store engagement features to their mobile apps and services. We use Low Energy Bluetooth beacons (such as Apple iBeacons) to trigger in-store engagements of different kinds when people are near to something of interest.

## What does the project do ? ##

The demo app features the 3 basics LocalSocial steps:
- Uniquely authenticate the mobile device on the LocalSocial platform.
- Discover PLACES and SHOPZONES nearby along with their associated OFFERS.
- Display welcome and award notifications to user (works in background mode too).

## Where to start? ##

1. Ensure you have LocalSocial enabled Beacons. You can order them from the LocalSocial [website](https://www.mylocalsocial.com/) or contact us for more details on how to add your own Beacons to LocalSocial. 

2. Go to the [localsocial developer site](https://dev.mylocalsocial.com/) and register for API keys. You will need API keys ror each App that you wish to use with the LocalSocial Library. All keys can me managed from your LocalSocial Developer Account. 

3. Update the following lines with the keys provided:

	config.client_id            = << Fetch at http.//dev.mylocalsocial.com >>;
	config.client_secret        = << Fetch at http.//dev.mylocalsocial.com >>;
	config.app_callback         = << Fetch at http.//dev.mylocalsocial.com >>;


4. Compile the demo App using XCode.