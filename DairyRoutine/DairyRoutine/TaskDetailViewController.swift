//
//  TaskDetailViewController.swift
//  DairyRoutine
//
//  Created by Qing Zhang on 5/22/18.
//  Copyright © 2018 Qing Zhang. All rights reserved.
//

import UIKit
import os.log
import UserNotifications


class TaskDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UNUserNotificationCenterDelegate {

    @IBOutlet var taskName: UITextField!
    @IBOutlet weak var taskImageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var task: Task?
    var center = UNUserNotificationCenter.current()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field's user input through delegate callbacks
        taskName.delegate = self
        
        // Set up views if editing an existing task
        if let task = task {
            navigationItem.title = task.name
            taskName.text = task.name
            taskImageView.image = task.photo
        }
        
        // Enable the Save button only info the text field has a valid Meal name.
        updateSaveButtonState()
        askPermissionForNotification()  // todo, for testing only in here
        self.registerCategories()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK Notification
    func askPermissionForNotification() {
//        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            (granted, error) in
            if granted {
                print("Yay! Authenrization successful!!")
                
            } else {
                print("D'oh")
            }
            
        }
    }
    
    func timeNotification(inSeconds: TimeInterval, completion:@escaping (_ success: Bool) -> ()) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "New GIF"
        content.subtitle = "subtitmlesdf "
        content.body = "this is the body part"
        content.sound = UNNotificationSound.default()
        let request = UNNotificationRequest(identifier: "customNotificaion", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func registerCategories() {
//        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Time to get up"
        content.body = "Get up on time and and start the day  right"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default()
        
        var dateComponents = DateComponents()
        dateComponents.hour = 14
        dateComponents.minute = 57
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // user swiped to unlock
                print("Default identifier, user swiped to unlock")
            case "show":
                // user tapped our "show more info..." button
                print("Show more information...")
                break
            default:
                break
            }
        }
        // you must call the completion handler when you're done
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // you must call the completion handler when you're done
        completionHandler([.alert, .sound, .badge])

    }
    
    // MARK: - Navigation

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The TaskViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = taskName.text ?? ""
        let photo = taskImageView.image
        
        // set the task to be pressed to TAskDetailTableViewController after the unwind segue
        task = Task(name: name, photo: photo!, desc: "")
        
        timeNotification(inSeconds: 10) { (success) in
            print(" In time notification........")
            if success {
                print("Successfully Notified!!!")
            }
        }
        
        scheduleNotification()

    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
 /*   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    
    
    //MARK: Actions
    @IBAction func selectImageAction(_ sender: UITapGestureRecognizer) {
        
        print("test image action....")
        
        //  hide the keyboard
        taskName.resignFirstResponder()
        
        //UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // the info dictionary may contain multiple representations of the image. You want to use the orginal
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as?
            UIImage else {
                fatalError("Expected a dictoriary containing an image, but was provided the following: \(info)")
        }
        
        // set photoImageView to display the selected image
        taskImageView.image = selectedImage
        
        //Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    func setDefaultLabelText( sender: UIButton) {
        
        
    }
    
   
    
    // MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = taskName.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    

}
