//
//  CompactLayout.swift
//  CofCApp
//
//  Created by Rahimi, Meena Nichole (Student) on 6/7/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import Foundation
// This lightweight data model is used by `ObjectLayoutDataSource` to retrieve
// the list of fields for a given object type.

struct CompactLayout: Codable {
    var fieldItems: [FieldItem]
}

extension CompactLayout {
    struct FieldItem: Codable {
        var layoutComponents: [LayoutComponent]
    }
}

extension CompactLayout {
    struct LayoutComponent: Codable {
        var value: String
    }
}
