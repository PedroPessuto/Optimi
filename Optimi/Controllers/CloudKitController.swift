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
	
//	func checkAccountStatus() async throws -> CKAccountStatus {
//		try await CKContainer.default().accountStatus()
//	}
	
	func fetchDeveloperRecords() async throws -> [Developer] {
		let name = "Pessuto"
		
		let query = CKQuery(
			recordType: "Developer",
			predicate: NSPredicate(value: true) // NSPredicate(format: "name == %@", name) -> buscar por nome enguar
		)
		
		query.sortDescriptors = [.init(key: DeveloperRecordKeys.name.rawValue, ascending: true)]
		
		let result = try await CKContainer.default().publicCloudDatabase.records(matching: query)
		let records = result.matchResults.compactMap { try? $0.1.get() }
		return records.compactMap(Developer.init)
	}
	
	func save(_ record: CKRecord) async throws {
		try await CKContainer.default().publicCloudDatabase.save(record)
	}
	
	func delete(_ dev: Developer, vm: FastingHistoryViewModel) {
		CKContainer.default().publicCloudDatabase.delete(withRecordID: dev.record.recordID) { result, error in
			if let result = result {
				print(result)
			}
			if let error = error {
				print(error)
			}
//			Task {
//				vm.developers = try await self.fetchDeveloperRecords()
//			}
		}
		
	}
}


@MainActor final class OnboardingViewModel: ObservableObject {
	private static let logger = Logger(subsystem: "com.optimi", category: String(describing: OnboardingViewModel.self))
	
	@Published private(set) var accountStatus: CKAccountStatus = .couldNotDetermine
	
	private let cloudKitService = CloudKitController()
	
//	func fetchAccountStatus() async {
//		do {
//			accountStatus = try await cloudKitService.checkAccountStatus()
//		} catch {
//			Self.logger.error("\(error.localizedDescription, privacy: .public)")
//		}
//	}
}

struct OnboardingView: View {
	@StateObject private var viewModel = OnboardingViewModel()
	@State private var accountStatusAlertShown = false
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		Button("startUsingApp") {
			if viewModel.accountStatus != .available {
				accountStatusAlertShown = true
			} else {
				dismiss()
			}
		}
		.alert("iCloudAccountDisabled", isPresented: $accountStatusAlertShown) {
			Button("cancel", role: .cancel, action: {})
		}
//		.task {
//			await viewModel.fetchAccountStatus()
//		}
	}
}

struct Fasting: Hashable {
	var start: Date
	var end: Date
	var goal: TimeInterval
}

enum FastingRecordKeys: String {
	case type = "Fasting"
	case start
	case end
	case goal
}

extension Fasting {
	
}



@MainActor final class NewFastingViewModel: ObservableObject {
	private static let logger = Logger(subsystem: "com.optimi", category: String(describing: NewFastingViewModel.self))
	
	@Published var fasting: Fasting = .init(start: .now, end: .now, goal: 16 * 3600)
	@Published private(set) var isSaving = false
	
	private let cloudkitService = CloudKitController()
	
	func save() async {
		isSaving = true
		
//		do {
////			try await cloudkitService.save(fasting.record)
//		} catch {
//			Self.logger.error("\(error.localizedDescription, privacy: .public)")
//		}
		
		isSaving = false
	}
}

struct NewFastingRecord: View {
	@StateObject private var viewModel = NewFastingViewModel()
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		Form {
			Section {
				DatePicker("start", selection: $viewModel.fasting.start)
				DatePicker("end", selection: $viewModel.fasting.end)
			}
			
			Section {
				Picker("goal", selection: $viewModel.fasting.goal) {
					ForEach([16, 18, 23], id: \.self) { hours in
							Text(String(hours))
							.tag(hours * 3600)
					}
				}
			}
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				Button("save") {
					Task {
						await viewModel.save()
						dismiss()
					}
				}.disabled(viewModel.isSaving)
			}
		}
		.navigationTitle("newFasting")
	}
}







final class FastingHistoryViewModel: ObservableObject {
	private static let logger = Logger(subsystem: "com.optimi", category: String(describing: FastingHistoryViewModel.self))
	
	@Published var interval: DateInterval = .init(start: .now.addingTimeInterval(-30 * 34 * 36000), end: .now)
	
	@Published private(set) var history: [Fasting] = []
	@Published private(set) var isLoading = false
	
	@Published var developers: [Developer] = []
	
	private let cloudKitService = CloudKitController()
	
	func fetch() async {
		isLoading = true
		
		do {
			developers = try await cloudKitService.fetchDeveloperRecords()
		} catch {
			Self.logger.error("\(error.localizedDescription, privacy: .public)")
		}
		
		isLoading = false
	}
}

struct FastingHistoryView: View {
	@StateObject private var viewModel = FastingHistoryViewModel()
	
	private let cloudKitService = CloudKitController()
	
	var body: some View {
		Text("FastingHistoryView!")
		
		Button("Delete") {
			Task {
				cloudKitService.delete(viewModel.developers.first!, vm: viewModel)
				viewModel.developers.removeAll { isso in
					isso.record.recordID == viewModel.developers.first?.record.recordID
				}
			}
		}
		
		Button("Create") {
			let record = CKRecord(recordType: "Developer")
			record.setValue("Pessuto", forKey: "name")
			
			Task {
				do {
					try await cloudKitService.save(record)
					await viewModel.fetch()
				} catch {
					print("Error: \(error)")
				}
			}
		}
		.onAppear {
			Task {
				await viewModel.fetch()
				print(viewModel.developers)
			}
		}
		
		List(viewModel.developers, id:\.self) { dev in
			VStack(alignment: .leading) {
				Text(dev.name)
			}
		}
		.redacted(reason: viewModel.isLoading ? .placeholder : [])
		.refreshable {
			await viewModel.fetch()
		}
		.task {
			await viewModel.fetch()
		}
	}
}

#Preview {
	FastingHistoryView()
}

struct Developer: Hashable {
	let name: String
	let record: CKRecord
	
	init(name: String, record: CKRecord) {
		self.name = name
		self.record = record
	}
	
	init?(from record: CKRecord) {
		guard
			let name = record[DeveloperRecordKeys.name.rawValue] as? String
		else { return nil }
		self = .init(name: name, record: record)
	}

}

enum DeveloperRecordKeys: String {
	case type = "Developer"
	case name
}
