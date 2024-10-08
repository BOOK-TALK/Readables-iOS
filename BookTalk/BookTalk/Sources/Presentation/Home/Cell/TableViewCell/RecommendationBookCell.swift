//
//  RecommendationBookCell.swift
//  BookTalk
//
//  Created by RAFA on 7/29/24.
//

import UIKit

protocol RecommendationBookCellDelegate: AnyObject {
    
    func recommendationBookCell(
        _ cell: RecommendationBookCell,
        didSelectBook book: DetailBookInfo
    )
}

final class RecommendationBookCell: BaseTableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: RecommendationBookCellDelegate?
    
    private var basicBookInfo: [BasicBookInfo] = []
    private var detailBookInfo: [DetailBookInfo] = []
    private let collectionView: UICollectionView
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: 15, bottom: 15, right: 15)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        registerCell()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    
    func bind(_ detailBookInfo: [DetailBookInfo]) {
        self.detailBookInfo = detailBookInfo
        self.basicBookInfo = detailBookInfo.map { $0.basicBookInfo }
        collectionView.reloadData()
    }
    
    // MARK: - Set UI
    
    override func setConstraints() {
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func registerCell() {
        collectionView.register(
            BookImageCell.self,
            forCellWithReuseIdentifier: BookImageCell.identifier
        )
    }
    
    private func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension RecommendationBookCell: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return basicBookInfo.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookImageCell.identifier,
            for: indexPath
        ) as? BookImageCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension RecommendationBookCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = detailBookInfo[indexPath.item]
        delegate?.recommendationBookCell(self, didSelectBook: selectedBook)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RecommendationBookCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (ScreenSize.width - 36) / 3
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
