//
//  ViewController.swift
//  Crap weather
//
//  Created by Michael Ferchak on 6/24/15.
//  Copyright © 2015 Michael Ferchak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var status:UILabel!
    
    @IBOutlet var cloudCoverLabel:UILabel!
    @IBOutlet var precipIntensityLabel:UILabel!
    @IBOutlet var precipProbabilityLabel:UILabel!
    @IBOutlet var temperatureLabel:UILabel!
    @IBOutlet var niceHoursLabel:UILabel!
    @IBOutlet weak var timeline_view: UIView!
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var pointer_x: NSLayoutConstraint!
    
    @IBOutlet weak var timeline_pointer: UIView!
    @IBOutlet var hourlySlider:UISlider!
    
    var forecast = Forecast()

    func time_for_forecast(forecast:NSDictionary) -> NSDate {
        let data_time = forecast.valueForKey("time") as! Int
        return NSDate(timeIntervalSince1970: NSTimeInterval(data_time))
    }
    
    func forecast_time_label(forecast:NSDictionary) -> String {
        let forecast_date = time_for_forecast(forecast)
        let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        return formatter.stringFromDate(forecast_date)
    }

    func refresh_status_for(forecast: NSDictionary) {
        if Forecast().is_pleasant_at(forecast) {
            status.text = "PLEASANT"
            status.textColor = UIColor.whiteColor()
        } else {
            status.text = "CRAP"
            status.textColor = UIColor.lightGrayColor()
        }
        
        if let cloudCover = forecast.valueForKey("cloudCover"),
            precipIntensity = forecast.valueForKey("precipIntensity"),
            precipProbability = forecast.valueForKey("precipProbability"),
            temperature = forecast.valueForKey("temperature") {
                cloudCoverLabel.text = "Cloud cover: \(cloudCover)"
                precipIntensityLabel.text = "Precipitation intensity: \(precipIntensity)"
                precipProbabilityLabel.text = "Precipitation probability: \(precipProbability)"
                temperatureLabel.text = "Temperature: \(temperature)"
                if hourlySlider.value != 0 {
                    time_label.text = self.forecast_time_label(forecast)
                } else {
                    time_label.text = "Currently"
                }
        }
    }
    
    @IBAction func hourly_slider_changed(sender: AnyObject) {
        timeline_view.layoutIfNeeded()
        let rounded_value = Int(hourlySlider.value)
        let width = timeline_view.bounds.width
        let x_constant = CGFloat(width) * ( CGFloat(hourlySlider.value) / CGFloat(hourlySlider.maximumValue) )
        
        pointer_x.constant = x_constant
        
        refresh_status_for(forecast.hourly[rounded_value])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecast.initialize()
        
        let nice_hours_count = Forecast().find_pleasant_blocks_in(forecast.hourly).count
        let total_hours_count = forecast.hourly.count
        niceHoursLabel.text = "\(nice_hours_count) of the next \(total_hours_count) hours are not bullshit"
        
        print(Forecast().find_pleasant_blocks_in(forecast.hourly).count)
        
        hourlySlider.maximumValue = Float(forecast.hourly.count) - 1.00
        
        render_timeline_view(forecast.hourly)
        refresh_status_for(forecast.current)
    }
    
    func render_timeline_view(forecast:[NSDictionary]) {
        timeline_view.layoutIfNeeded()
        
        let total_hours = forecast.count-1
        let slice_height = timeline_view.bounds.height
        let slice_width = timeline_view.bounds.width / CGFloat(total_hours)

        for index in 0...total_hours {
            let newView = UIView()
            let this_x = CGFloat(slice_width) * CGFloat(index)
            
            if (forecast[index].valueForKey("pleasant") as! Bool) == true {
                newView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            } else {
                newView.backgroundColor = UIColor.blackColor()
            }
            
            newView.translatesAutoresizingMaskIntoConstraints = false
            timeline_view.addSubview(newView)
            timeline_view.sendSubviewToBack(newView)
            
            let horizontalConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: timeline_view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: this_x)
            timeline_view.addConstraint(horizontalConstraint)
            
            let verticalConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: timeline_view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
            timeline_view.addConstraint(verticalConstraint)
            
            let widthConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: slice_width)
            newView.addConstraint(widthConstraint)
            
            let heightConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: slice_height)
            newView.addConstraint(heightConstraint)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

