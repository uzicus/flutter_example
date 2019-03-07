import UIKit
import Flutter
import Foundation
import ContactsUI

@available(iOS 9.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller = window.rootViewController as! FlutterViewController
    let contactsChannel = FlutterMethodChannel(
        name: "contacts",
        binaryMessenger: controller
    )
    
    contactsChannel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) -> Void in
        if (call.method == "getContacts") {
            let contacts = NSMutableArray()
            
            AppDelegate.getContacts().forEach({ (contact: CNContact) in
                let dictionary: NSDictionary = [
                    "NAME" : contact.givenName as NSString,
                    "MOBILE" : contact.phoneNumbers.first?.value.value(forKey: "digits") ?? NSString()
                ]
                contacts.add(dictionary)
            })
            
            result(contacts)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    class func getContacts() -> [CNContact] { //  ContactsFilter is Enum find it below
        let contactStore = CNContactStore()
        
        var contacts = [CNContact]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor
        ]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        
        return contacts
    }
}
