//
//  FoodSuggestionsViewController.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 11.07.2024.
//

import UIKit
import SwiftUI
import Combine

struct FoodSuggestionsScrollView: UIViewControllerRepresentable {

    let meals: [SuggestedMeal]

    func makeUIViewController(context: Context) -> FoodSuggestionsViewController {
        let viewModel = FoodSuggestionsScrollViewModel()
        viewModel.configure(meals: meals)
        let viewController = FoodSuggestionsViewController(style: .plain)
        viewController.viewModel = viewModel
        return viewController
    }

    func updateUIViewController(_ uiViewController: FoodSuggestionsViewController, context: Context) {
        uiViewController.viewModel.configure(meals: meals)
    }
}

class FoodSuggestionsScrollViewModel {

    private let mealsSubject = CurrentValueSubject<[SuggestedMeal], Never>([])

    var mealsPublisher: AnyPublisher<[SuggestedMeal], Never> {
        mealsSubject.eraseToAnyPublisher()
    }

    func configure(meals: [SuggestedMeal]) {
        mealsSubject.send(meals)
    }
}

class FoodSuggestionsViewController: UITableViewController {

    var viewModel: FoodSuggestionsScrollViewModel!
    private var cancellables = Set<AnyCancellable>()

    lazy var source: UITableViewDiffableDataSource<FoodSuggestionsSection, SuggestedMeal> = .init(tableView: tableView) { [weak self] (tableView, indexPath, meal) -> UITableViewCell? in
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodSuggestionsCell", for: indexPath) as? FoodSuggestionsCellView
        cell?.contentConfiguration = UIHostingConfiguration {
            SuggestedMealItemView(meal: meal,
                                  searchRequest: "",
                                  isSelected: false,
                                  onTap: { _ in })
            .padding(.vertical, .itemVerticalPadding)
        }
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        registerCells()
        configureViewModel()
    }

    private func configureViewModel() {
        viewModel.mealsPublisher
            .sink(with: self) { this, meals in
                this.updateMeals(meals)
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

        source.apply(snapshot, animatingDifferences: true)
    }

    private func configureTableView() {
        tableView?.separatorStyle = .none
        tableView?.backgroundColor = .white
        tableView.sectionHeaderTopPadding = 0
        source.defaultRowAnimation = .none
    }

    private func registerCells() {
        tableView.register(FoodSuggestionsCellView.self, forCellReuseIdentifier: "FoodSuggestionsCell")
    }
}

extension FoodSuggestionsViewController {
}

class FoodSuggestionsCellView: UITableViewCell {
}

private extension CGFloat {
    static let itemVerticalPadding: CGFloat = 10
}
