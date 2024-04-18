//
//  SwiftUIView.swift
//  
//
//  Created by Denis Khlopin on 05.04.2024.
//

import SwiftUI
import AppStudioStyles

struct WaterHistoryBottomView: View {
    let history: WaterHistoryData
    let onDelete: (Date) -> Void
    let onEdit: (Date) -> Void
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
                ForEach(history.water, id: \.self) { record in
                    HStack(alignment: .center, spacing: .recordItemsSpacing) {
                        VStack(alignment: .leading, spacing: .recordDateSpacing) {
                            Text(record.date.currentLocaleFormatted(with: "MMM dd"))
                                .font(.poppins(.body))
                                .foregroundStyle(Color.studioBlackLight)
                        }
                        .padding(.vertical, .recordContentVerticalPadding)
                        .padding(.leading, .recordContentHorizontalPadding)

                        Spacer()

                        Text(record.quantity)
                            .font(.poppinsMedium(.body))
                            .foregroundStyle(Color.studioBlackLight)

                        Text(record.unit)
                            .font(.poppinsMedium(.body))
                            .foregroundStyle(Color.studioBlackLight)

                        if record.isGoalReached {
                            Image.checkmark
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color.studioSky)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 5)
                                .frame(width: .iconSize, height: .iconSize)
                                .padding(.trailing, .recordContentHorizontalPadding)
                        } else {
                            Spacer()
                                .frame(width: .iconSize)
                                .padding(.trailing, .recordContentHorizontalPadding)
                        }

                    }
                    .background(Color.studioGreyFillCard)
                    .withSwipeActions(leftActions: [], rightActions: [deleteAction(with: record)])
                    .onTapGesture {
                        onEdit(record.date)
                    }
                }
            }
            .continiousCornerRadius(.cornerRadius)
            .padding(.horizontal, .horizontalPadding)

            Spacer()
        }
    }

    func deleteAction(with record: WaterWithGoal) -> SwipeAction {
        .init(title: "Delete",
              image: nil,
              backgroundColor: .studioRed,
              foregroundColor: .white,
              buttonWidth: 80) {
            onDelete(record.date)
        }
    }
}

private extension WaterHistoryBottomView {
    enum Localization {
        static let title = "Water Log"// NSLocalizedString("FastingHistoryScreen.title", bundle: .module, comment: "")
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
    WaterHistoryBottomView(history: .init(water: []), onDelete: {_ in }, onEdit: {_ in }, onAdd: {})
}
