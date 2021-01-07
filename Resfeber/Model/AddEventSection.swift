//
//  AddEventSection.swift
//  Resfeber
//
//  Created by David Wright on 12/24/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

protocol InputRow {
    var attributeTitle: String? { get }
    var placeholderText: String? { get }
}

// MARK: - Sections

enum AddEventSection: Int, CaseIterable {
    case nameAndLocation
    case category
    case dates
    case notes
    
    var rows: [InputRow] {
        switch self {
        case .nameAndLocation: return NameAndLocationInputRow.allCases
        case .category: return CategoryInputRow.allCases
        case .dates: return DateInputRow.allCases
        case .notes: return NotesInputRow.allCases
        }
    }
    
    var headerText: String? { return nil }
    var footerText: String? { return nil }
}

// MARK: - Rows By Section

// Section 0
enum NameAndLocationInputRow: Int, CaseIterable {
    case location
    case name
}

// Section 1
enum CategoryInputRow: Int, CaseIterable {
    case category
}

// Section 2
enum DateInputRow: Int, CaseIterable {
    case startDate
    case endDate
}

// Section 3
enum NotesInputRow: Int, CaseIterable {
    case notes
}

// MARK: - InputRow Conformance

extension NameAndLocationInputRow: InputRow {
    var attributeTitle: String? { return nil }
    
    var placeholderText: String? {
        switch self {
        case .name: return "Event name (optional)"
        case .location: return "Location (required)"
        }
    }
}

extension CategoryInputRow: InputRow {
    var attributeTitle: String? { return "Category" }
    var placeholderText: String? { return "None" }
}

extension DateInputRow: InputRow {
    var attributeTitle: String? {
        switch self {
        case .startDate: return "Start Date"
        case .endDate: return "End Date"
        }
    }
    
    var placeholderText: String? {
        switch self {
        case .startDate: return "None"
        case .endDate: return "None"
        }
    }
}

extension NotesInputRow: InputRow {
    var attributeTitle: String? { return nil }
    var placeholderText: String? { return "Notes" }
}
