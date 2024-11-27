//
//  AppMetricaService.swift
//  Tracker
//
//  Created by Alexander Bralnin on 25.11.2024.
//
import Foundation
import AppMetricaCore


enum AnalyticsServiceError: Error {
    case createReporterError
}


final class AnalyticsService {
    private static let API_KEY = "b7550e4e-f2bf-421d-8e9a-34b915844858"
    static let shared = AnalyticsService()
    
    private init() {}
    
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: AnalyticsService.API_KEY) else { return }
        
        AppMetrica.activate(with: configuration)
    }
    
    func trackEvent(event: AnalyticsEvent, params: [AnyHashable : Any]) {
        guard let reporter = AppMetrica.reporter(for: AnalyticsService.API_KEY) else {
            Log.error(error: AnalyticsServiceError.createReporterError, message: "failed to create reporter")
            return
        }
        reporter.resumeSession()
        
        reporter.reportEvent(name: event.rawValue, parameters: params, onFailure: { error in
            Log.error(error: error, message: "failed to report event")
        })
        
        reporter.pauseSession()
    }
}
