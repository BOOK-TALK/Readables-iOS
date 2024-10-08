//
//  CompleteReadingCell.swift
//  BookTalk
//
//  Created by 김민 on 8/4/24.
//

import UIKit

final class CompletedReadingCell: BaseTableViewCell {

    // MARK: - Properties

    private let titleLabel = UILabel()
    private let completedReadingPeopleTableView = UITableView()

    private var users: [GoalUserModel]?

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setDelegate()
        registerCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Bind

    func bind(with goalUsers: [GoalUserModel]) {
        titleLabel.text = "지금까지 \(goalUsers.count)명이 이 책을 다 읽었어요!"
        users = goalUsers

        updateEmptyState()
        completedReadingPeopleTableView.reloadData()
    }

    private func updateEmptyState() {
        if let users = users, users.isEmpty {
            completedReadingPeopleTableView.setEmptyMessage("아직 완독한 사람이 없어요.")
        } else {
            completedReadingPeopleTableView.restore()
        }
    }

    // MARK: - UI Setup

    override func setViews() {
        selectionStyle = .none
        
        contentView.backgroundColor = .clear

        titleLabel.do {
            $0.font = .systemFont(ofSize: 19, weight: .semibold)
            $0.text = "지금까지 17명이 이 책을 다 읽었어요!"
        }

        completedReadingPeopleTableView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.contentInset = .init()
            $0.separatorStyle = .none
        }
    }

    override func setConstraints() {
        [titleLabel, completedReadingPeopleTableView].forEach {
            contentView.addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }

        completedReadingPeopleTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(contentView.safeAreaLayoutGuide)
            $0.height.equalTo(250)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }

    // MARK: - Helpers

    private func setDelegate() {
        completedReadingPeopleTableView.dataSource = self
        completedReadingPeopleTableView.delegate = self
    }

    private func registerCell() {
        completedReadingPeopleTableView.register(
            ReadingPeopleCell.self,
            forCellReuseIdentifier: ReadingPeopleCell.identifier
        )
    }
}

extension CompletedReadingCell: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return min(users?.count ?? 0, 5)
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ReadingPeopleCell.identifier,
            for: indexPath
        ) as? ReadingPeopleCell else { return UITableViewCell() }

        cell.bind(with: users?[indexPath.row])

        return cell
    }
}

extension CompletedReadingCell: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 50
    }
}

