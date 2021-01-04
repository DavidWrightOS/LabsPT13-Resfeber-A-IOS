//
//  EventDetailCell.swift
//  Resfeber
//
//  Created by David Wright on 12/25/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import MapKit

protocol EventDetailCellDelegate: class {
    func didUpdateData(forCell cell: EventDetailCell)
}

class EventDetailCell: UITableViewCell {
    static let cellReuseIdentifier = "add-event-cell-reuse-identifier"
    
    // MARK: - Properties
    
    var inputRow: InputRow?
    weak var delegate: EventDetailCellDelegate?
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = RFColor.groupedBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
