# BLE Peripheral macOS App

## Project Summary

- A macOS app built with Swift, Cocoa, and CoreBluetooth.
- Acts as a BLE Peripheral that advertises a custom GATT service.
- Defines two characteristics:
  - rxCharacteristic (notify) to send data to the central.
  - txCharacteristic (writeWithoutResponse) to receive data from the central.
- Starts advertising when the peripheral is ready.
- Stops advertising once a central subscribes.
- Sends user-input messages to the connected central.
- Receives and logs messages written by the central.
- Displays Bluetooth state and activity logs in a debug area.
