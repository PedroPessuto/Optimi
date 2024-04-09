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
		.task {
			await viewModel.fetchAccountStatus()
		}
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
	var record: CKRecord {
		let record = CKRecord(recordType: FastingRecordKeys.type.rawValue)
		record[FastingRecordKeys.goal.rawValue] = goal
		record[FastingRecordKeys.start.rawValue] = start
		record[FastingRecordKeys.end.rawValue] = end
		return record
	}
}

extension CloudKitController {
	func save(_ record: CKRecord) async throws {
		try await CKContainer.default().publicCloudDatabase.save(record)
	}
}

@MainActor final class NewFastingViewModel: ObservableObject {
	private static let logger = Logger(subsystem: "com.optimi", category: String(describing: NewFastingViewModel.self))
	
	@Published var fasting: Fasting = .init(start: .now, end: .now, goal: 16 * 3600)
	@Published private(set) var isSaving = false
	
	private let cloudkitService = CloudKitController()
	
	func save() async {
		isSaving = true
		
		do {
			try await cloudkitService.save(fasting.record)
		} catch {
			Self.logger.error("\(error.localizedDescription, privacy: .public)")
		}
		
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


extension Fasting {
	init?(from record: CKRecord) {
		guard
			let start = record[FastingRecordKeys.start.rawValue] as? Date,
			let end = record[FastingRecordKeys.end.rawValue] as? Date,
			let goal = record[FastingRecordKeys.goal.rawValue] as? TimeInterval
		else { return nil }
		self = .init(start: start, end: end, goal: goal)
	}
}

extension CloudKitController {
	func fetchFastingRecords(in interval: DateInterval) async throws -> [Fasting] {
		let predicate = NSPredicate(
			format: "\(FastingRecordKeys.start.rawValue) >= %@ AND \(FastingRecordKeys.end.rawValue) <= %@",
			interval.start as NSDate,
			interval.end as NSDate
		)
		
		let query = CKQuery(
			recordType: FastingRecordKeys.type.rawValue,
			predicate: predicate
		)
		
		query.sortDescriptors = [.init(key: FastingRecordKeys.end.rawValue, ascending: true)]
		
		let result = try await CKContainer.default().publicCloudDatabase.records(matching: query)
		let records = result.matchResults.compactMap { try? $0.1.get() }
		return records.compactMap(Fasting.init)
	}
}

@MainActor final class FastingHistoryViewModel: ObservableObject {
	private static let logger = Logger(subsystem: "com.optimi", category: String(describing: FastingHistoryViewModel.self))
	
	@Published var interval: DateInterval = .init(start: .now.addingTimeInterval(-30 * 34 * 36000), end: .now)
	
	@Published private(set) var history: [Fasting] = []
	@Published private(set) var isLoading = false
	
	private let cloudKitService = CloudKitController()
	
	func fetch() async {
		isLoading = true
		
		do {
			history = try await cloudKitService.fetchFastingRecords(in: interval)
		} catch {
			Self.logger.error("\(error.localizedDescription, privacy: .public)")
		}
		
		isLoading = false
	}
}

struct FastingHistoryView: View {
	@StateObject private var viewModel = FastingHistoryViewModel()
	
	var body: some View {
		List(viewModel.history, id:\.self) { fasting in
			VStack(alignment: .leading) {
				Text(fasting.start, style: .time)
				Text(fasting.end, style: .time)
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
