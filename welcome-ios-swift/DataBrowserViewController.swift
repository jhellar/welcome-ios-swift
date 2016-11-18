import UIKit
import SWRevealViewController
import FeedHenry

class DataBrowserViewController: UIViewController {
    @IBOutlet var menuButton:UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveData(_ sender: AnyObject) {
        print("Call cloud was clicked")
        self.saveButton.isEnabled = false
        
        let args = ["collection": "Users", "document": ["data": nameLabel.text ?? ""]] as [String : Any]
        if let delegate = UIApplication.shared.delegate as? AppDelegate, !delegate.initSuccess {
            delegate.presentAlert("Initialisation failure", message: "Relaunch the app once you fixed the configuration plist file.")
            self.saveButton.isEnabled = true
        } else { // init is successful
            FH.cloud(path: "saveData", method: HTTPMethod.POST,
                     args: args as [String : AnyObject]?, headers: nil,
                     completionHandler: {(resp: Response, error: NSError?) -> Void in
                        self.saveButton.isEnabled = true
                        self.view.endEditing(true)
                        if let error = error {
                            print("Cloud Call Failed, \(error)")
                            return
                        }
                        let alert = UIAlertController(title: "Success", message: "Yay, your data was saved in the cloud", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok, cool!", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
            })
        }
    }
}
