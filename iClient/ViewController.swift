import CoreBluetooth
import UIKit

class ViewController: UIViewController {
    
    private var peripheralManager: CBPeripheralManager!
    private var rxCharacteristic: CBMutableCharacteristic!
    private var txCharacteristic: CBMutableCharacteristic!
    private var connectedCentral: CBCentral!
    
    override func viewDidLoad() {
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func startAdvertise() {
        
        guard txCharacteristic != nil else {
            appendLog(log: "Please wait until the peripheral gets ready")
            return
        }
        
        guard connectedCentral == nil else {
            appendLog(log: "central is still connected")
            return
        }
        
        guard !peripheralManager.isAdvertising else {
            appendLog(log: "peripheral is advertising now")
            return
        }
        
        peripheralManager.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [CBUUIDs.service_uuid]
        ])
        
        appendLog(log: "Advertising a new service: \(CBUUIDs.service_uuid)")
    }
    
    func sendData(msg: String) {
        writeToCentral(msg: msg)
    }
    
    private func appendLog(log: String){
        print(log)
    }
}

extension ViewController: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        switch peripheral.state {
        case .poweredOff:
            appendLog(log: "bluetooth is powered OFF")
        case .poweredOn:
            appendLog(log: "bluetooth is powered ON")
            setupPeripheral()
            startAdvertise()
        default:
            appendLog(log: "bluetooth is NOT supported")
        }
    }
    
    private func setupPeripheral() {
        // Build our service.
        // Start with the CBMutableCharacteristic.
        let rxCharacteristic = CBMutableCharacteristic(
            type: CBUUIDs.rxCharacteristic_uuid,
            properties: .notify,
            value: nil,
            permissions: .readable
        )
        let txCharacteristic = CBMutableCharacteristic(
            type: CBUUIDs.txCharacteristic_uuid,
            properties: .writeWithoutResponse,
            value: nil,
            permissions: .writeable
        )
        
        // Create a service from the characteristic.
        let transferService = CBMutableService(type: CBUUIDs.service_uuid, primary: true)
        
        // Add the characteristic to the service.
        transferService.characteristics = [rxCharacteristic, txCharacteristic]
        
        // And add it to the peripheral manager.
        peripheralManager.add(transferService)
        
        // Save the characteristic for later.
        self.rxCharacteristic = rxCharacteristic
        self.txCharacteristic = txCharacteristic
        appendLog(log: "The peripheral is ready for advertising")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        
        guard characteristic == rxCharacteristic else {
            return
        }
        
        connectedCentral = central
        peripheralManager.stopAdvertising()
        appendLog(log: "central is subscribed to rxCharacteristic")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        guard characteristic == rxCharacteristic else {
            return
        }
        
        connectedCentral = nil
        appendLog(log: "central is unsubscribed from rxCharacteristic")
    }
    
    private func writeToCentral(msg: String){
        
        guard let connectedCentral = connectedCentral else {
            appendLog(log: "central is not connected")
            return
        }
        
        let didSend = peripheralManager.updateValue(
            msg.data(using: .utf8)!,
            for: rxCharacteristic,
            onSubscribedCentrals: [connectedCentral]
        )
        
        if didSend {
            appendLog(log: "Sent: \(msg) at \(NSDate())")
        } else {
            appendLog(log: "tranmit queue is full")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for aRequest in requests {
            guard let requestValue = aRequest.value,
                  let requestValue = String(data: requestValue, encoding: .utf8)
            else {
                continue
            }
            appendLog(log: "Recieved: \(requestValue) at \(NSDate())")
        }
    }
}
