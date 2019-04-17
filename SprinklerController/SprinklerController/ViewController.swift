//
//  ViewController.swift
//  SprinklerController
//
//  Created by Roderic Campbell on 4/15/19.
//  Copyright © 2019 Thumbworks. All rights reserved.
//

import UIKit
import IntentsUI

class ViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorColor = .clear
        tableView.register(ZoneCell.self, forCellReuseIdentifier: ZoneCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let dataSource = ZoneDataSource()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        dataSource.refresh()
    }
}

extension ViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        dismiss(animated: true)
    }

    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        dismiss(animated: true)
    }
}

extension ViewController: ZoneDataSourceDelegate {

    func didPressAddButton(cell: UITableViewCell) {
        guard let objects = dataSource.zoneModel,
            let cellIndexPath = tableView.indexPath(for: cell) else {
            return
        }
        let zone = objects[cellIndexPath.row]
        let intent = WateringZoneIntent()
        intent.zoneName = zone.name
        intent.zoneID = zone.zoneID
        intent.time = 60
        guard let shortcut = INShortcut(intent: intent) else {
            return
        }
        let intentViewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        intentViewController.delegate = self
        present(intentViewController, animated: true)
    }

    func didUpdateContent() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func didFailToUpdateContent(with error: Error) {
        print("TODO alert this error \(error)")
    }
}

