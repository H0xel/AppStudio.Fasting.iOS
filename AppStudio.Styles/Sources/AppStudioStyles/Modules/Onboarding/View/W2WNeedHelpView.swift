import SwiftUI

struct W2WNeedHelpView: View {
    var body: some View {
        HStack(spacing: .spacing) {
            Text("W2W.needHelp".localized(bundle: .module))
                .font(.poppins(.body))
            Image.questionCircle
                .font(.system(size: 16))
        }
        .foregroundStyle(Color.studioBlackLight)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 10
}

#Preview {
    W2WNeedHelpView()
}
