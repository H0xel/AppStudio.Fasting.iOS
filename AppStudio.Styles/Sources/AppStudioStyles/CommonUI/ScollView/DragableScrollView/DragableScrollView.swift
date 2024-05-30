//
//  DragableScrollView.swift
//  
//
//  Created by Руслан Сафаргалеев on 15.05.2024.
//

import SwiftUI


struct DragableScrollView<Content: View>: UIViewRepresentable {

    @Binding var isDragging: Bool
    @Binding var dragOffset: CGFloat
    @Binding var scrollOffset: CGFloat
    @Binding var contentOffset: CGFloat
    private let content: () -> Content

    init(isDragging: Binding<Bool>,
         dragOffset: Binding<CGFloat>,
         scrollOffset: Binding<CGFloat>,
         contentOffset: Binding<CGFloat>,
         content: @escaping () -> Content) {
        self._isDragging = isDragging
        self._dragOffset = dragOffset
        self._scrollOffset = scrollOffset
        self._contentOffset = contentOffset
        self.content = content
    }

    func makeUIView(context: Context) -> UIScrollView {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.delegate = context.coordinator
        view.keyboardDismissMode = .onDrag

        guard let contentView = UIHostingController(rootView: content()).view else {
            return view
        }
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        let constraints = [
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: contentView.intrinsicContentSize.height)
        ]
        NSLayoutConstraint.activate(constraints)
        context.coordinator.setConstraints(constraints)
        context.coordinator.setContentView(contentView)
        return view
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.updateConstraints(scrollView: uiView)

    }

    func makeCoordinator() -> DragableScrollViewCoordinator {
        DragableScrollViewCoordinator(dragOffset: $dragOffset,
                                      contentOffset: $contentOffset,
                                      scrollOffset: $scrollOffset,
                                      isDragging: $isDragging)
    }
}

class DragableScrollViewCoordinator: NSObject, UIScrollViewDelegate {

    @Binding var isDragging: Bool
    @Binding var dragOffset: CGFloat
    @Binding var contentOffset: CGFloat
    @Binding var scrollOffset: CGFloat

    private var isInitialized = false
    private var constraints: [NSLayoutConstraint] = []
    private var contentView: UIView?

    init(dragOffset: Binding<CGFloat>,
         contentOffset: Binding<CGFloat>,
         scrollOffset: Binding<CGFloat>,
         isDragging: Binding<Bool>) {
        self._contentOffset = contentOffset
        self._dragOffset = dragOffset
        self._isDragging = isDragging
        self._scrollOffset = scrollOffset
    }

    func setConstraints(_ constraints: [NSLayoutConstraint]) {
        self.constraints = constraints
    }

    func setContentView(_ view: UIView) {
        contentView = view
    }

    func updateConstraints(scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollViewSize = scrollView.frame.size.height
        guard let contentView, !isInitialized, contentHeight > 0, scrollViewSize > 0 else { return }
        NSLayoutConstraint.deactivate(constraints)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        if contentHeight > scrollViewSize {
            NSLayoutConstraint.activate([
                contentView.heightAnchor.constraint(lessThanOrEqualToConstant: contentView.intrinsicContentSize.height)
            ])
        } else {
            NSLayoutConstraint.activate([
                contentView.heightAnchor.constraint(equalToConstant: contentView.intrinsicContentSize.height)
            ])
        }
        isInitialized = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offset = scrollView.contentOffset.y

        let contentHeight = scrollView.contentSize.height
        let scrollViewSize = scrollView.frame.size.height
        if contentHeight > scrollViewSize, offset > contentHeight - scrollViewSize {
            let xPosition = scrollView.contentOffset.x
            let scrollPosition = CGPoint(x: xPosition, y: contentHeight - scrollViewSize)
            scrollOffset = scrollPosition.y
            dragOffset = -scrollPosition.y
            scrollView.setContentOffset(scrollPosition, animated: false)
            return
        }
        scrollOffset = offset
        guard scrollView.isDragging, !scrollView.isDecelerating else {
            return
        }
        if offset > 0, contentOffset > 0 {
            scrollView.setContentOffset(.init(x: 0, y: 0), animated: false)
        }
        dragOffset = -offset
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isDragging = false
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDragging = false
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isDragging = false
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isDragging = false
    }
}
