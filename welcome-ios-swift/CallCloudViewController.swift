import UIKit
import SWRevealViewController
import FeedHenry

class CallCloudViewController: UIViewController {
    @IBOutlet var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var cloudButton: UIButton!
    
    @IBOutlet weak var result: UITextView!
    
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
    
    @IBAction func callcloud(_ sender: UIButton) {
        print("Call cloud was clicked")
        self.cloudButton.isEnabled = false
        if let delegate = UIApplication.shared.delegate as? AppDelegate, !delegate.initSuccess {
            delegate.presentAlert("Initialisation failure", message: "Relaunch the app once you fixed the configuration plist file.")
            self.cloudButton.isEnabled = true
        } else { // init is successful
            FH.cloud(path: "hello", method: HTTPMethod.POST,
                     args: nil, headers: nil,
                     completionHandler: {(resp: Response, error: NSError?) -> Void in
                        self.cloudButton.isEnabled = true
                        if let error = error {
                            print("Cloud Call Failed, \(error)")
                            self.result.text = "Error during Cloud call: \(error.userInfo[NSLocalizedDescriptionKey]!)"
                            return
                        }
                        if let parsedRes = resp.parsedResponse as? [String:String] {
                            self.result.text = parsedRes["text"]
                        }
            })
        }
    }
}
