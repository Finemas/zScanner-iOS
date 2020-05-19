//
//  MediaPreviewViewController.swift
//  zScanner
//
//  Created by Jan Provazník on 12/05/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit

protocol MediaPreviewCoordinator: BaseCoordinator {
    func createNewMedia(mediaType: MediaType)
    func finishEdit()
}

class MediaPreviewViewController: BaseViewController {

    // MARK: Instance part
    let media: Media
    let viewModel: NewDocumentMediaViewModel
    
    unowned let coordinator: MediaPreviewCoordinator
    
    // MARK: Lifecycle
    init(viewModel: NewDocumentMediaViewModel, media: Media, coordinator: MediaPreviewCoordinator) {
        self.viewModel = viewModel
        self.media = media
        self.coordinator = coordinator
        
        super.init(coordinator: coordinator, theme: .dark)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMedia()
        setupButtons()
        setupView()
    }
    
    // MARK: View setup
    func setupView() {
        fatalError("setupView function needs to override")
    }
    
    func setupButtons() {
        view.backgroundColor = .black
        title = viewModel.folderName
        
        buttonStackView.addArrangedSubview(againButton)
        buttonStackView.addArrangedSubview(nextPhotoButton)
        buttonStackView.addArrangedSubview(continueButton)
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea).inset(10)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(70)
        }
    }
    
    // MARK: Helpers
    func loadMedia() {
        fatalError("loadMedia function needs to override")
    }
    
    func stopPlayingVideo() {
        // When user will click on a button the video should stop playing, so in Video Preview ViewController should be this function is overridden and properly handle it
    }
    
    @objc func retake() {
        stopPlayingVideo()
        coordinator.createNewMedia(mediaType: media.type)
    }
    
    @objc func createAnotherMedia() {
        stopPlayingVideo()
        viewModel.addMedia(media)
        coordinator.createNewMedia(mediaType: media.type)
    }
    
    @objc func showMediaSelection() {
        stopPlayingVideo()
        viewModel.addMedia(media)
        coordinator.finishEdit()
    }
    
    // MARK: Lazy instance part
    lazy var buttonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillEqually
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        return buttonStackView
    }()
    
    private lazy var againButton: UIButton = {
        let againButton = UIButton()
        againButton.setTitle("newDocumentPhotos.againButton.title".localized, for: .normal)
        againButton.addTarget(self, action: #selector(retake), for: .touchUpInside)
        againButton.titleLabel?.font = .footnote
        againButton.titleLabel?.textColor = .white
        return againButton
    }()
    
    private lazy var nextPhotoButton: UIButton = {
        let nextPhotoButton = UIButton()
        nextPhotoButton.setTitle("newDocumentPhotos.nextPhoto.title".localized, for: .normal)
        nextPhotoButton.addTarget(self, action: #selector(createAnotherMedia), for: .touchUpInside)
        nextPhotoButton.titleLabel?.font = .footnote
        nextPhotoButton.titleLabel?.textColor = .white
        nextPhotoButton.layer.cornerRadius = 8
        nextPhotoButton.layer.borderWidth = 1
        nextPhotoButton.layer.borderColor = UIColor.white.cgColor
        nextPhotoButton.backgroundColor = .black
        return nextPhotoButton
    }()
    
    private lazy var continueButton: UIButton = {
        let continueButton = UIButton()
        continueButton.setTitle("newDocumentPhotos.continue.title".localized, for: .normal)
        continueButton.addTarget(self, action: #selector(showMediaSelection), for: .touchUpInside)
        continueButton.titleLabel?.font = .footnote
        continueButton.titleLabel?.textColor = .white
        continueButton.layer.cornerRadius = 6
        continueButton.backgroundColor = .blue
        return continueButton
    }()
}