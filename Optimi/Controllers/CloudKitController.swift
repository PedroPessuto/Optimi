//
//  CloudKitController.swift
//  Optimi
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 09/04/24.
//

import Foundation
import CloudKit
import os
import SwiftUI

final class CloudKitController {
	private static let logger = Logger(subsystem: "com.optimi", category: String(describing: CloudKitController.self))
	
	func checkAccountStatus() async throws -> CKAccountStatus {
		try await CKContainer.default().accountStatus()
	}
}


@MainActor final class OnboardingViewModel: ObservableObject {
	private static let logger = Logger(subsystem: "com.optimi", category: String(describing: OnboardingViewModel.self))
	
	@Published private(set) var accountStatus: CKAccountStatus = .couldNotDetermine
	
	private let cloudKitService = CloudKitController()
	
	func fetchAccountStatus() async {
		do {
			accountStatus = try await cloudKitService.checkAccountStatus()
		} catch {
			Self.logger.error("\(error.localizedDescription, privacy: .public)")
		}
	}
}

struct OnboardingView: View {
	@StateObject private var viewModel = OnboardingViewModel()
	@State private var accountStatusAlertShown = false
}
