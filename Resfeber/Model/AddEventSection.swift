//
//  AddEventSection.swift
//  Resfeber
//
//  Created by David Wright on 12/24/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

protocol InputRow {
    var inputCellType: InputCellType { get }
    var attributeTitle: String? { get }
    var placeholderText: String? { get }
}

enum InputCellType {
    case textField
    case textView
    case subtitle
    case detail
}

// MARK: - Add Event Sections

enum AddEventSection: CaseIterable {
    case nameAndLocation
    case category
    case dates
    case notes
    
    var rows: [InputRow] {
        switch self {
        case .nameAndLocation: return NameAndLocationRow.allCases
        case .category: return CategoryRow.allCases
        case .dates: return DatesRow.allCases
        case .notes: return NotesRow.allCases
        }
    }
    
    var headerText: String? { return nil }
    var footerText: String? { return nil }
}

// TableView Rows
// Each enum defined below is its own section, with the cases making up the rows in that section

// MARK: - Name and Location Rows

enum NameAndLocationRow: CaseIterable, InputRow {
    case name
    case location
    
    var inputCellType: InputCellType {
        switch self {
        case .name: return .textField
        case .location: return .subtitle
        }
    }
    
    var attributeTitle: String? {
        switch self {
        case .name: return "Event Name"
        case .location: return "Location"
        }
    }
    
    var placeholderText: String? {
        switch self {
        case .name: return "Add an event name"
        case .location: return "Add a location"
        }
    }
}

// MARK: - Category Rows

enum CategoryRow: CaseIterable, InputRow {
    case category
    
    var inputCellType: InputCellType { return .detail }
    var attributeTitle: String? { return "Category" }
    var placeholderText: String? { return "Select category" }
}

// MARK: - Dates Rows

enum DatesRow: CaseIterable, InputRow {
    case startDate
    case endDate
    
    var inputCellType: InputCellType { return .detail }
    
    var attributeTitle: String? {
        switch self {
        case .startDate: return "Start Date"
        case .endDate: return "End Date"
        }
    }
    
    var placeholderText: String? {
        switch self {
        case .startDate: return "Add a start date"
        case .endDate: return "Add an end date"
        }
    }
}

// MARK: - Notes Rows

enum NotesRow: CaseIterable, InputRow {
    case notes
    
    var inputCellType: InputCellType { return .textView }
    var attributeTitle: String? { return "Notes" }
    var placeholderText: String? { return "Add notes" }
}
