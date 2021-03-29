//
//  AmiiboWidget.swift
//  AmiiboWidget
//
//  Created by Miguel Planckensteiner on 2/15/21.
//

import WidgetKit
import SwiftUI
import Intents



struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), name: "")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, name: "")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.amiiboWidget")
        let name = userDefaults?.value(forKey: "name") as? String ?? "No Text"

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, name: name)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let name: String
}

struct AmiiboWidgetEntryView : View {
    var entry: Provider.Entry
    
    

    var body: some View {
        
        ZStack {
            
                Text(entry.name)
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(.black)
                    
        }
        .background(Color.red)
        .padding()
       
        
    }
    
}

@main
struct AmiiboWidget: Widget {
    let kind: String = "AmiiboWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            AmiiboWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct AmiiboWidget_Previews: PreviewProvider {
    static var previews: some View {
        AmiiboWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), name: ""))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
