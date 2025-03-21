# BLE Peripheral iOS App

## Project Summary

- An iOS app built with Swift and UIKit using CoreBluetooth.
- Functions as a BLE Peripheral that advertises a custom GATT service.
- Defines two characteristics:
  - rxCharacteristic (notify) to send data to the central.
  - txCharacteristic (writeWithoutResponse) to receive data from the central.
- Automatically starts advertising when Bluetooth is powered on.
- Stops advertising once a central subscribes.
- Sends data to the central programmatically via a function call.
- Logs Bluetooth events and data transmissions using print statements.
- Designed for minimal UI interaction with console-based debugging.
