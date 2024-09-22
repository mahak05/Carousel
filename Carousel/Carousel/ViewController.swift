//
//  ViewController.swift
//  Carousel
//
//  Created by Mahak Agarwal on 21/09/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        let imageNames = ["image1", "image2", "image3"]
        for (index, subview) in stackView.arrangedSubviews.enumerated() {
            if let imageView = subview as? UIImageView {
                if index < imageNames.count {
                    imageView.image = UIImage(named: imageNames[index])
                }
            }
        }
        pageControl.numberOfPages = imageNames.count
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.gray
    }

}
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.frame.width
        let scrollOffset = scrollView.contentOffset.x
        let centerOffset = scrollOffset + scrollViewWidth / 2
        
        for (_, subview) in stackView.arrangedSubviews.enumerated() {
            guard let imageView = subview as? UIImageView else { continue }

            let imageCenter = imageView.convert(imageView.center, to: scrollView.superview).x
            let distanceFromCenter = abs(centerOffset - imageCenter)
            let distancePercentage = min(1, distanceFromCenter / (scrollViewWidth / 2))

            let minScale: CGFloat = 0.8
            let maxScale: CGFloat = 1.3
            let scale = (1 - distancePercentage) * (maxScale - minScale) + minScale

            UIView.animate(withDuration: 0.1) {
                imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }

            let zPositionValue = 1 - distancePercentage * 2
            imageView.layer.zPosition = zPositionValue
        }

        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        let page: CGFloat = CGFloat(sender.currentPage)
        scrollView.setContentOffset(CGPoint(x: page * scrollView.frame.width, y: 0), animated: true)
    }
}

