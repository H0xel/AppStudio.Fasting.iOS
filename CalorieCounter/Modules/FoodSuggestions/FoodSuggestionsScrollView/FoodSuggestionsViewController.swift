//
//  FoodSuggestionsViewController.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 11.07.2024.
//

import UIKit
import SwiftUI
import Combine

enum FoodSuggestionsSection {
    case history
}

class FoodSuggestionsViewController: UITableViewController {

    private let viewModel: FoodSuggestionsScrollViewModel

    init(viewModel: FoodSuggestionsScrollViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var cancellables = Set<AnyCancellable>()

    lazy var source: UITableViewDiffableDataSource<FoodSuggestionsSection, SuggestedMeal> = .init(
        tableView: tableView
    ) { [weak self] tableView, indexPath, meal -> UITableViewCell? in
        guard let self else { return nil }
        let cell = tableView.dequeueReusableCell(withIdentifier: .cellId, for: indexPath) as? FoodSuggestionsCellView
        cell?.contentConfiguration = UIHostingConfiguration {
            SuggestedMealItemView(meal: meal,
                                  searchRequestPublisher: self.viewModel.searchRequestPublisher,
                                  isSelected: self.viewModel.isSelected(meal: meal.mealItem)) { meal in
                self.viewModel.select(meal)
            } onPlusTap: { meal in
                self.viewModel.toggleSelection(meal)
            }
            .padding(.vertical, .itemVerticalPadding)
            .padding(.horizontal, .horizontalPadding)
            .id(meal)
        }
        .margins(.all, .zero)
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        registerCells()
        configureViewModel()
    }

    private func configureViewModel() {
        viewModel.mealPublisher
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, meals in
                this.updateMeals(meals)
            }
            .store(in: &cancellables)

        viewModel.reloadPublisher
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, _ in
                let snapshot = this.source.snapshot()
                this.source.applySnapshotUsingReloadData(snapshot)
            }
            .store(in: &cancellables)
    }

    private func updateMeals(_ meals: [SuggestedMeal]) {
        var result: Set<SuggestedMeal> = []
        var snapshot = NSDiffableDataSourceSnapshot<FoodSuggestionsSection, SuggestedMeal>()
        snapshot.appendSections([.history])
        for meal in meals where !result.contains(meal) {
            snapshot.appendItems([meal])
            result.insert(meal)
        }
        source.apply(snapshot, animatingDifferences: false)
    }

    private func configureTableView() {
        tableView?.separatorStyle = .none
        tableView?.backgroundColor = .white
        tableView.sectionHeaderTopPadding = 0
        source.defaultRowAnimation = .none
        tableView.keyboardDismissMode = .onDrag
    }

    private func registerCells() {
        tableView.register(FoodSuggestionsCellView.self, forCellReuseIdentifier: .cellId)
    }
}

extension FoodSuggestionsViewController {

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .inputHeight
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidScroll(scrollView)
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.scrollViewWillBeginDragging()
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                            withVelocity velocity: CGPoint,
                                            targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        viewModel.scrollViewEndScrolling()
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewModel.scrollViewEndScrolling()
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.scrollViewEndScrolling()
    }

    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        viewModel.scrollViewEndScrolling()
    }
}

class FoodSuggestionsCellView: UITableViewCell {
}

private extension CGFloat {
    static let itemVerticalPadding: CGFloat = 10
    static let horizontalPadding: CGFloat = 16
    static let inputHeight: CGFloat = 124
}

private extension String {
    static let cellId = "FoodSuggestionsCell"
}
