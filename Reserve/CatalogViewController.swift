//
//  CatalogViewController.swift
//  Reserve
//
//  Created by Edward Cluster on 4/12/22.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class CatalogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BookPostCellDelegate {
    func buttonTapped(cell: BookPostCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        print(books[indexPath.row])
        PFUser.current()!.add(books[indexPath.row], forKey: "checkedOut")
        PFUser.current()!.saveInBackground { (success, error) in
            if success {
                print("Comment saved")
            } else {
                print("Error saving comment")
            }
        }
        
//        PFUser.current()!.removeObjects(in: [books[indexPath.row]], forKey: "checkedOut")
//        PFUser.current()!.saveInBackground { (success, error) in
//            if success {
//                print("Comment saved")
//            } else {
//                print("Error saving comment")
//            }
//        }
    }
    
    
    var books = [PFObject]()
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let query = PFQuery(className: "Book")

        query.findObjectsInBackground { (books, error) in
            if books != nil {
                self.books = books!
                self.tableView.reloadData()
            } else {
                print("There are no books")
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookPostCell") as! BookPostCell
        
        let book = books[indexPath.row]
        
        cell.titleLabel.text = book["title"] as! String
        cell.authorLabel.text = book["author"] as! String
        
        cell.delegate = self
        
        let imageFile = book["cover"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.photoView.af.setImage(withURL: url)

        return cell
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
