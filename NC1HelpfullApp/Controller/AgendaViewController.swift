//
//  AgendaViewController.swift
//  NC1HelpfullApp
//
//  Created by Eki Rifaldi on 15/03/20.
//  Copyright © 2020 Eki Rifaldi. All rights reserved.
//

import UIKit
import EventKit

class AgendaViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var movies: [String] = ["satu","dua","tiga"]
    var frame = CGRect.zero
    var agenda: AgendaModel? = nil
    
    var calendars: [EKCalendar]?
    var events: [EKEvent]?
    var allEvents: [EKEvent] = []
    
    
    @IBOutlet weak var labelBentuk: UILabel!
    @IBOutlet weak var labelDefinisi: UILabel!
    @IBOutlet weak var labelJenis: UILabel!
    @IBOutlet weak var labelTempat: UILabel!
    @IBOutlet weak var labelTanggal: UILabel!
    @IBOutlet weak var labelWaktu: UILabel!
    @IBOutlet weak var agendaView: UIView!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pageControl.numberOfPages = movies.count
        setupScreens()
        
        scrollView.delegate = self
        
        loadAgendasData()
    }
    
    @IBAction func defdescSegmentedValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //            defdescLabel.text = agenda?.getDefinition()
            self.agendaView.isHidden = false
            self.view.layoutIfNeeded()
        } else if sender.selectedSegmentIndex == 1 {
            //            defdescLabel.text = agenda?.getDescription()
            self.agendaView.isHidden = true
            self.view.layoutIfNeeded()
        }
        self.agendaView.setNeedsUpdateConstraints()
    }
    
    func setupScreens() {
        for index in 0..<movies.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: movies[index])
            
            self.scrollView.addSubview(imgView)
        }
        
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(movies.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    //    MARK: - event
    
    func loadAgendasData(){
        //        defdescLabel.text = agenda!.getDefinition()
        eventTitleLabel.text = agenda!.getTitle()
        //                    eventImageView.image = #imageLiteral(resourceName: agenda!.getImage())
        labelWaktu.text = agenda!.getWaktu()
        labelTempat.text = agenda!.getTempat()
        labelTanggal.text = getNowDateTime()
        labelDefinisi.text = agenda!.getDefinition()
        labelJenis.text = agenda!.getJenis()
        labelBentuk.text = agenda!.getBentukKegiatan()
    }
    
    func getNowDateTime() -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        let date = Date()
        return dateFormatterPrint.string(from: date)
        
    }
}
