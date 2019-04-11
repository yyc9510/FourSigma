//
//  SolarInfoViewController.swift
//  foursigma
//
//  Created by 姚逸晨 on 6/4/19.
//  Copyright © 2019 YICHEN YAO. All rights reserved.
//

import UIKit
import PDFKit

class SolarInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Save Money"
        
        let pdfView = PDFView()

        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        guard let path = Bundle.main.url(forResource: "solarInfo", withExtension: "pdf") else { return }

        if let document = PDFDocument(url: path) {
            pdfView.document = document
        }

        pdfView.autoScales = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
