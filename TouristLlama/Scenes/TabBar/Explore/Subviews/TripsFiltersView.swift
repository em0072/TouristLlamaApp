//
//  TripsFiltersView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 25/08/2023.
//

import SwiftUI

struct TripsFiltersView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var tripStyle:TripStyle?
    @State private var startDate: Date?
    @State private var endDate: Date?

    private let onFiltersSet: (Filters) -> Void
    
    init(filters: Filters, onFiltersSet: @escaping (Filters) -> Void) {
        self._tripStyle = State(initialValue: filters.tripStyle)
        self._startDate = State(initialValue: filters.startDate)
        self._endDate = State(initialValue: filters.endDate)
        self.onFiltersSet = onFiltersSet
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                ScrollView {
                    TripStylePicker(title: String.Trips.filtersTripStyle, selectedStyle: $tripStyle)
                        .padding(.bottom, 20)
                    
                    datesFilterView
                        .padding(.horizontal, 20)
                }
                
                Spacer()
                
                doneButton
                    .padding(.horizontal, 20)
            }
            .navigationBarTitle(String.Trips.filtersTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        clear()
                    } label: {
                        Text(String.Trips.filtersClear)
                    }
                    .disabled(isEmpty)
                    
                }
            }
        }
    }
}

extension TripsFiltersView {
    
    private var isEmpty: Bool {
        tripStyle == nil && startDate == nil && endDate == nil
    }
    
    private func clear() {
        tripStyle = nil
        startDate = nil
        endDate = nil
    }

    private var datesFilterView: some View {
        HStack(spacing: 20) {
            FramedDatePickerView(title: String.Trips.filtersStartDate,
                                 placeholder: String.Trips.filtersSelectDate,
                                 selection: $startDate,
                                 minimumDate: Date(),
                                 maximumDate: endDate)
            FramedDatePickerView(title: String.Trips.filtersEndDate,
                                 placeholder: String.Trips.filtersSelectDate,
                                 selection: $endDate,
                                 minimumDate: startDate ?? Date())
        }
    }
    
    private var doneButton: some View {
        Button(String.Main.done) {
            let filter = Filters(tripStyle: tripStyle, startDate: startDate, endDate: endDate)
            onFiltersSet(filter)
            dismiss()
        }
        .buttonStyle(WideBlueButtonStyle())
    }
    
    
}

struct TripsFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        TripsFiltersView(filters: .init()) { _ in }
    }
}
