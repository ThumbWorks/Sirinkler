# Sirinkler
A siri controlled sprinkler system


## Steps to setup

1. Obtain an API Key
  1. Visit https://app.rach.io 
  2. Log in
  3. Tap the account icon on the top right
  4. Tap `Get API Key`
  5. Copy the key and paste it into `Config.plist`
2. Build and run

This app fetches your Rachio user, the devices, and all of the zones. It then displays all of the zones. Tapping a zone begins a 1 minute watering session. You can also donate an intent to Siri so that you can run zones through Siri. For example: "Hey Siri, water the strawberries".