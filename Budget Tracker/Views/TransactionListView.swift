//
//  TransactionListView.swift
//  Budget Tracker
//
//  Created by Zain Malik on 28/08/2024.
//

import SwiftUI
import CoreData


struct TransactionListView: View {
    @FetchRequest var transactions: FetchedResults<Transaction>
    
    let onDeleteTransaction: (Transaction) -> Void
    
    init(request: NSFetchRequest<Transaction>, onDeleteTransaction: @escaping (Transaction) -> Void) {
        _transactions = FetchRequest(fetchRequest: request)
        self.onDeleteTransaction = onDeleteTransaction
    }

    var body: some View {
        if transactions.isEmpty {
            Text("No transactions.")
                .font(.title3)
                .foregroundColor(.gray)
                .padding()
        } else {
            List {
                ForEach(transactions) { transaction in
                    HStack {
                        Text(transaction.title ?? "")
                            .font(.body)
                            .foregroundColor(.white)
                        Spacer()
                        Text(transaction.total as NSNumber, formatter: NumberFormatter.currency)
                            .font(.body)
                            .foregroundColor(transaction.total >= 0 ? .green : .red)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                    )
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 1) // Add vertical padding between items
                }
                .onDelete { offsets in
                    offsets.map { transactions[$0] }.forEach(onDeleteTransaction)
                }
            }
            .listStyle(.plain)
        }
    }
}
