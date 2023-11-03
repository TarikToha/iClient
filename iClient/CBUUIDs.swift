import Foundation
import CoreBluetooth


struct CBUUIDs {
    static let service_uuid = CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    static let txCharacteristic_uuid = CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")
    static let rxCharacteristic_uuid = CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")
}
