//
//  VideoMessageView.swift
//  ChatApp
//
//  Created by qq on 2024.10.20.
//

import Foundation
import UIKit
import ChatLayout
import AVFoundation

final class VideoMessageView : UIView, ContainerCollectionViewCellDelegate {
    private var viewPortWidth : CGFloat = 300
    private var playerLayer : PlayerLayer?
    private var controller : VideoMessageController?
    private var videoViewWidthConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func setup(with controller : VideoMessageController?) {
        self.controller = controller
    }
    
    deinit {
        playerLayer?.player?.replaceCurrentItem(with: nil)
        playerLayer = nil
    }
    
    func prepareForReuse() {
    }
    
    func reloadData() {
        guard let controller,
              let playerLayer,
              let data = controller.message.video,
              let url = data.url
        else {
            return
        }
        backgroundColor = .systemGray
        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        playerLayer.player = player
        
        let multiplier = CGFloat(data.height) / CGFloat(data.width)
        let width = min(CGFloat(data.width), viewPortWidth * Constants.maxWidth)
        let videoViewOriginalWidth = playerLayer.widthAnchor.constraint(equalToConstant: CGFloat(width))
        let videoViewOriginalHeight = playerLayer.heightAnchor.constraint(equalTo: playerLayer.widthAnchor, multiplier: multiplier)
        
        videoViewOriginalWidth.isActive = true
        videoViewOriginalHeight.isActive = true
    }
    
    private func setupSubviews() {
        layoutMargins = .zero
        insetsLayoutMarginsFromSafeArea = false
        translatesAutoresizingMaskIntoConstraints = false
        
        playerLayer = .init()
            .withoutAutoresizingMaskIntoConstraints
        guard let playerLayer else {
            return
        }
        addSubview(playerLayer)
        NSLayoutConstraint.activate([
            playerLayer.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            playerLayer.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            playerLayer.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            playerLayer.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
        
        videoViewWidthConstraint = playerLayer.widthAnchor.constraint(lessThanOrEqualToConstant: viewPortWidth * Constants.maxWidth)
        videoViewWidthConstraint?.isActive = true
    }
}

fileprivate class PlayerLayer : UIView {
    public override class var layerClass: AnyClass {
        get { AVPlayerLayer.self }
    }
    internal var playerLayer : AVPlayerLayer {
        get { layer as! AVPlayerLayer }
    }
    public var player : AVPlayer? {
        get { playerLayer.player }
        set {
            playerLayer.player = newValue
            playerLayer.isHidden = (playerLayer.player == nil)
        }
    }
    public var resizeMode : AVLayerVideoGravity? {
        get { playerLayer.videoGravity }
        set {
            guard let resizeMode = newValue
            else {
                playerLayer.videoGravity = .resizeAspectFill
                return
            }
            playerLayer.videoGravity = resizeMode
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
