//
//  CategoryListModel.swift
//  SwiftuiConcurrency
//
//  Created by hb on 08/01/25.
//

import Foundation

class CategoryListModel: WSResponseData {
    var category : String?
    var categoryId : String?
    var categoryImage : String?
    
    override init() {
        super.init()
    }
    
    private enum CodingKeys: String, CodingKey {
        case category = "category"
        case categoryId = "category_id"
        case categoryImage = "category_image"
    }
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(category, forKey: .category)
        try container.encode(categoryId, forKey: .categoryId)
        try container.encode(categoryImage, forKey: .categoryImage)
    }
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId)
        categoryImage = try values.decodeIfPresent(String.self, forKey: .categoryImage)
    }
}
