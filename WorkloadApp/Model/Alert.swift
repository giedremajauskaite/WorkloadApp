//
//  Alert.swift
//  WorkloadApp
//
//  Created by Giedre Majauskaite on 10/18/20.
//

import Foundation

struct Alert {
    
    let alertsIntervals:[(name: String, time: Int)] = [("None", -1),
                                                       ("At the time of event", 0),
                                                       ("5 minutes before", 5),
                                                       ("10 minutes before", 10),
                                                       ("15 minutes before", 15),
                                                       ("30 minutes before", 30),
                                                       ("1 hour before", 60),
                                                       ("2 hours before",120),
                                                       ("1 day before", 60*24),
                                                       ("2 days before", 60*24*2),
                                                       ("1 week before", 60*24*7)]

//  var  alertsIntervals = ["None" : 0,
//                     "At the time of event" : 0,
//                     "5 minutes before" : 0,
//                     "10 minutes before" : 0,
//                     "15 minutes before" : 0,
//                     "30 minutes before" : 0,
//                     "1 hours before" : 0,
//                     "2 hours before" : 0,
//                     "1 days before" : 0,
//                     "2 days before" : 0,
//                     "1 week before" : 0,
//    ]

}
