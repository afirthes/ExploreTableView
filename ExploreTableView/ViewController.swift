//
//  ViewController.swift
//  ExploreTableView
//
//  Created by Afir Thes on 29.09.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var fontsFammilies: [String] = UIFont.familyNames
    lazy var fontsDict: [Int:[FontModel]] = {
        var fontDict:[Int:[FontModel]] = [:]
        for (i, fn) in fontsFammilies.enumerated() {
            fontDict[i] = UIFont.fontNames(forFamilyName:fn).map({ fontName in
                FontModel.init(name: fontName, isFavorite: false)
            })
        }
        return fontDict
    }()
    
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.tintColor = .green
        refreshControl.attributedTitle = NSAttributedString(string: "Shuffle fonts...")
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(shuffleFonts), for: .valueChanged)

    }
    
    @objc func shuffleFonts() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //self.fonts = self.fonts.shuffled()
            
            for (i, _) in self.fontsFammilies.enumerated() {
                self.fontsDict[i] = self.fontsDict[i]?.shuffled()
            }
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func toggleEditingMode() {
        let isEditingNewState = !isEditing
        super.setEditing(isEditingNewState, animated: true)
        tableView.setEditing(isEditingNewState, animated: true)
        
        if isEditingNewState {
            navigationItem.leftBarButtonItem?.title = "Done"
            navigationItem.leftBarButtonItem?.style = .done
            
        } else {
            navigationItem.leftBarButtonItem?.title = "Edit"
            navigationItem.leftBarButtonItem?.style = .plain
        }
    }


}


// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // обычная практика убирать выделение
        if let cell = tableView.cellForRow(at: indexPath) {
            
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let fontModel = self.fontsDict[indexPath.section]?[indexPath.row] else { return nil }
        let title = fontModel.isFavorite ? "Unfavor" : "Favor"
        let isFavorite = fontModel.isFavorite
        
        let action = UIContextualAction(style: .normal, title: title) { _, _, complete in
            self.fontsDict[indexPath.section]?[indexPath.row].isFavorite = !isFavorite
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return fontsFammilies.count
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fontsFammilies[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fontsDict[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let font = fontsDict[indexPath.section]?[indexPath.row]
        
        cell.textLabel?.text = font!.name
        
        if font!.isFavorite {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.fontsDict[indexPath.section]?.remove(at: indexPath.row)
            tableView.endUpdates()
        }
        
        
        
    }
    
}

