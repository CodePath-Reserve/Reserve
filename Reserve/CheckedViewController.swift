//
//  CheckedViewController.swift
//  Reserve
//
//  Created by Edward Cluster on 4/19/22.
//

import UIKit
import Parse

class CheckedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CheckedBookCellDelegate {
    func buttonTapped(cell: CheckedBookCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        var book = books[indexPath.row]
        let query = PFQuery(className: "Book")
        query.getObjectInBackground(withId: book.objectId!) { (obj, error) in
            if error == nil {
                obj!["status"] = true
                obj?.saveInBackground()
                book = obj!
            } else {
                print("that was a fail!!")
            }
        }
        
        print(book)
        
        PFUser.current()!.removeObjects(in: [book], forKey: "checkedOut")
        PFUser.current()!.saveInBackground { (success, error) in
            if success {
                print("Book returned")
                let alertDisapperTimeInSeconds = 1.5
                let alert = UIAlertController(title: nil, message: "Book returned", preferredStyle: .actionSheet)
                self.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
                  alert.dismiss(animated: true)
                }
            } else {
                print("Error returning book")
                let alertDisapperTimeInSeconds = 1.5
                let alert = UIAlertController(title: nil, message: "Return failure", preferredStyle: .actionSheet)
                self.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
                  alert.dismiss(animated: true)
                }
            }
        }
       viewDidAppear(true)
}
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var books = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.books = PFUser.current()!["checkedOut"]  as! [PFObject]
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckedBookCell") as! CheckedBookCell
        let book = books[indexPath.row]
        cell.delegate = self

        let query = PFQuery(className: "Book")
        query.getObjectInBackground(withId: book.objectId!) { (obj, error) in
            if error == nil {
                cell.titleLabel.text = obj!["title"] as! String
                cell.authorLabel.text = obj!["author"] as! String

                let imageFile = obj!["cover"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!
                cell.photoView.af.setImage(withURL: url)
            } else {
                print("that was a fail!!")
            }
        }
        return cell
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.window?.rootViewController = loginViewController
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
