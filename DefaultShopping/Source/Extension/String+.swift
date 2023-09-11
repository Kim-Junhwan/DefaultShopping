//
//  String+.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/11.
//

import Foundation

extension String {
    func removeHTMLTag() -> Self {
        return self.replacingOccurrences(of: "<b>|</b>", with: "", options: .regularExpression)
    }
}
