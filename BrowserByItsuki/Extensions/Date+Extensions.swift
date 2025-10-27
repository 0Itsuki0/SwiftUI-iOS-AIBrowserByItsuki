//
//  Date+Extensions.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//

import Foundation

extension Date {
   var dateIdentifier: DateComponents {
       return Calendar.current.dateComponents([.calendar, .timeZone, .yearForWeekOfYear, .weekOfYear, .dayOfYear], from: self)
   }
}
