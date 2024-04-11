//
//  FastingHistoryBottomView.swift
//
//
//  Created by Amakhin Ivan on 19.03.2024.
//

import SwiftUI
import AppStudioStyles

struct FastingHistoryBottomView: View {
    let records: [FastingHistoryRecord]
    let onDelete: (String) -> Void
    let onEdit: (String) -> Void
    let onAdd: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .emptySpacing) {
            // MARK: - Title
            HStack(spacing: .zero) {
                Text(Localization.title)
                    .font(.poppinsBold(.buttonText))
                    .foregroundStyle(Color.studioBlackLight)

                Spacer()

                Image.plusEx
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        onAdd()
                    }
            }
            .padding(.horizontal, .titleHorizontalPadding)
            .padding(.bottom, .titleBottomPadding)


            // MARK: - History Records
            VStack(alignment: .center, spacing: .recordsSpacing) {
                ForEach(records, id: \.self) { record in
                    HStack(alignment: .center, spacing: .recordItemsSpacing) {
                        VStack(alignment: .leading, spacing: .recordDateSpacing) {
                            Text(record.intervalDateTitle)
                                .font(.poppins(.body))
                                .foregroundStyle(Color.studioBlackLight)

                            Text(record.intervalTimeTitle)
                                .font(.poppins(.description))
                                .foregroundStyle(Color.studioGrayText)
                        }
                        .padding(.vertical, .recordContentVerticalPadding)
                        .padding(.leading, .recordContentHorizontalPadding)

                        Spacer()

                        Text(record.durationTitle)
                            .font(.poppinsMedium(.body))
                            .foregroundStyle(Color.studioBlackLight)

                        record.icon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .iconSize, height: .iconSize)
                            .padding(.trailing, .recordContentHorizontalPadding)

                    }
                    .background(Color.studioGreyFillCard)
                    .withSwipeActions(leftActions: [], rightActions: [deleteAction(with: record)])
                    .onTapGesture {
                        onEdit(record.id)
                    }
                }
            }
            .continiousCornerRadius(.cornerRadius)
            .padding(.horizontal, .horizontalPadding)

            Spacer()
        }
    }

    func deleteAction(with record: FastingHistoryRecord) -> SwipeAction {
        .init(title: "Delete",
              image: nil,
              backgroundColor: .studioRed,
              foregroundColor: .white,
              buttonWidth: 80) {
            onDelete(record.id)
        }
    }
}

private extension FastingHistoryBottomView {
    enum Localization {
        static let title = NSLocalizedString("FastingHistoryScreen.title", bundle: .module, comment: "")
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let emptySpacing: CGFloat = 0
    static let titleHorizontalPadding: CGFloat = 36
    static let titleBottomPadding: CGFloat = 16

    static let recordsSpacing: CGFloat = 2
    static let recordDateSpacing: CGFloat = 4
    static let recordItemsSpacing: CGFloat = 8

    static let recordContentVerticalPadding: CGFloat = 16
    static let recordContentHorizontalPadding: CGFloat = 20
    static let iconSize: CGFloat = 24

    static let cornerRadius: CGFloat = 20
    static let horizontalPadding: CGFloat = 16
}

#Preview {
    FastingHistoryBottomView(records: FastingHistoryData.mock.records) { _ in
    } onEdit: { _ in
    } onAdd: {
    }
}
