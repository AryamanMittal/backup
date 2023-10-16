//
//  SearchResultsViewController.swift
//  QuickReturn
//
//  Created by aryaman mittal on 11/10/23.
//

import UIKit
import Alamofire
class SearchResultsViewController: UIViewController,UITableViewDataSource,UITabBarDelegate,UITableViewDelegate{
    var searchQuery: String = ""
    var book:[Datum] = []
    @IBOutlet weak var searchTableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        self.navigationItem.title = "Results"
        getIssueBooks()
        let rightBarButton = UIBarButtonItem(title: "All Books", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        let nib  = UINib(nibName: "booksCell", bundle: nil)
        searchTableView.register(nib, forCellReuseIdentifier: "booksCell")

        // Do any additional setup after loading the view.
    }
    @objc func rightBarButtonTapped() {
        let allbookCon:allBooksView = self.storyboard?.instantiateViewController(identifier: "books_screen") as! allBooksView
        navigationController?.pushViewController(allbookCon, animated: true)
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:booksCell = searchTableView.dequeueReusableCell(withIdentifier: "booksCell" ,for: indexPath) as! booksCell
        cell.nameBookLabel.text! = book[indexPath.row].name
        cell.authorOfBook.text! = book[indexPath.row].author
        let availabelBooks = String(book[indexPath.row].available)
        let totalBooks = String(book[indexPath.row].total)
        cell.availableButtonAsLabel.titleLabel?.text = "\(availabelBooks)/\(totalBooks)"
        cell.pagesLabel.text! = "Pg. \(book[indexPath.row].pages)"
        cell.descriptionLabel.text! = "Condtions : " + book[indexPath.row].description
        return cell
    }
    func getIssueBooks(){
        let searchData = Searchname(name: searchQuery)
        AF.request("https://arcanists-04-3jz1.onrender.com/api/v1/getbookbyname",method: HTTPMethod.post,parameters: searchData,encoder: JSONParameterEncoder.default).response {
            (responseObj:AFDataResponse<Data?>)
            in
            if(responseObj.data != nil){
                do{
                    guard let data = responseObj.data else {
                        print(String(describing: responseObj.error))
                        return
                      }
                    let bookData = try JSONDecoder().decode(Search.self, from: data)
                    if(bookData.success){
                        self.book = bookData.data
                        print(self.book)
                        DispatchQueue.main.async {
                            self.searchTableView.reloadData()
                        }
                    }else{
                        self.openAlert(title: "Alert", message: "\(bookData.message)", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [UIAlertAction.Style.default], actions: [{ _ in
                            print("Okay clicked!")
                        }])
                    }
                }
                catch{
                        print("Error in json parsing ", error)
                    
                }
            }
        
        }
    }

}
