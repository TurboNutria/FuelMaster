//
//  FuelMaster_WidgetBundle.swift
//  FuelMaster-Widget
//
//  Created by Aura Silos on 30/10/22.
//

import WidgetKit
import SwiftUI

@main
struct FuelMaster_WidgetBundle: WidgetBundle {
    var body: some Widget {
        FuelMaster_Widget()
        FuelMaster_WidgetLiveActivity()
    }
}
