//
//  ZoneDataSource.swift
//  SprinklerController
//
//  Created by Roderic Campbell on 4/15/19.
//  Copyright © 2019 Thumbworks. All rights reserved.
//

import UIKit
import RachioModel
import RachioService

protocol ZoneDataSourceDelegate: class {
    func didUpdateContent()
    func didFailToUpdateContent(with error: Error)
    func didPressAddButton(cell: UITableViewCell)
}

class ZoneDataSource: NSObject {

    let rachioService: RachioService
    var zoneModel: [Zone]?
    weak var delegate: ZoneDataSourceDelegate?

    init(service: RachioService = RachioService()) {
        self.rachioService = service
    }

    public func refresh() {
        rachioService.fetchZones { [weak self] (zone, error) in
            if let zone = zone {
                self?.zoneModel = zone
                self?.delegate?.didUpdateContent()
            } else if let error = error {
                self?.delegate?.didFailToUpdateContent(with: error)
            }
        }
    }
}

extension ZoneDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let zone = zoneModel?[indexPath.row] {
            rachioService.beginWatering(zoneID: zone.zoneID) { error in
                if let error = error {
                    print("error begining watering service \(error)")
                }
            }
        }
    }
}

extension ZoneDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zoneModel?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView .dequeueReusableCell(withIdentifier: ZoneCell.reuseID) as? ZoneCell else {
            fatalError()
        }
        if let zone = zoneModel?[indexPath.row] {
            cell.update(with: zone)
            cell.delegate = self
            rachioService.image(for: zone) { image, error in
                cell.zoneImageView.image = image
            }
        }
        return cell
    }
}

extension ZoneDataSource: ZoneCellDelegate {
    func addSiri(cell: ZoneCell) {
        delegate?.didPressAddButton(cell: cell)
    }
}

private extension ZoneCell {
    func update(with zone: Zone) {
        nameLabel.text = zone.name
    }
}
