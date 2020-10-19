//
//  Alert.swift
//  WorkloadApp
//
//  Created by Giedre Majauskaite on 10/18/20.
//

import Foundation

struct Alert {
    
    let alertsIntervals:[(name: String, time: Int)] = [("None", 90),
                                                       ("At the time of event", 0),
                                                       ("5 minutes before", 5),
                                                       ("10 minutes before", 10),
                                                       ("15 minutes before", 15),
                                                       ("30 minutes before", 3),
                                                       ("1 hour before", 1),
                                                       ("2 hours before",2),
                                                       ("1 day before", 1),
                                                       ("2 days before", 2),
                                                       ("1 week before", 1)]

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
