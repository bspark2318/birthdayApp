//
//  MonthStruct.swift
//  BirthdayApp
//
//  Created by BumSu Park on 2022/05/15.
//

import Foundation
import SwiftUI

struct MonthStruct
{
    var monthType: MonthType
    var dayInt: Int
    
    func day() -> String
    {
        return String(dayInt)
    }
}

enum MonthType
{
    case Previous
    case Current
    case Next
    
}
