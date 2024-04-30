//
//  TrackerServicePreview.swift
//  
//
//  Created by Amakhin Ivan on 25.04.2024.
//

import AppStudioAnalytics

class TrackerServicePreview: TrackerService {
    func track<AnalyticEvent>(event: AnalyticEvent) where AnalyticEvent : AppStudioAnalytics.MirrorEnum {}
    
    func set(userId: String) {}
    
    func initialize() {}
    
    
}
