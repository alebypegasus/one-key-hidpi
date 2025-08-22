import SwiftUI
import AppKit

struct ContentView: View {
    @StateObject private var viewModel = HiDPIViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            SidebarView(selectedTab: $selectedTab)
            
            switch selectedTab {
            case 0:
                DashboardView(viewModel: viewModel)
            case 1:
                MonitorConfigView(viewModel: viewModel)
            case 2:
                BackupView(viewModel: viewModel)
            case 3:
                DiagnosticsView(viewModel: viewModel)
            case 4:
                SettingsView(viewModel: viewModel)
            default:
                DashboardView(viewModel: viewModel)
            }
        }
        .frame(minWidth: 900, minHeight: 600)
        .background(.regularMaterial)
    }
}

struct SidebarView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        List {
            NavigationLink(destination: EmptyView(), tag: 0, selection: $selectedTab) {
                Label("Dashboard", systemImage: "gauge")
            }
            
            NavigationLink(destination: EmptyView(), tag: 1, selection: $selectedTab) {
                Label("Monitor Configuration", systemImage: "display")
            }
            
            NavigationLink(destination: EmptyView(), tag: 2, selection: $selectedTab) {
                Label("Backup & Restore", systemImage: "externaldrive")
            }
            
            NavigationLink(destination: EmptyView(), tag: 3, selection: $selectedTab) {
                Label("Diagnostics", systemImage: "stethoscope")
            }
            
            NavigationLink(destination: EmptyView(), tag: 4, selection: $selectedTab) {
                Label("Settings", systemImage: "gear")
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 200)
    }
}

struct DashboardView: View {
    @ObservedObject var viewModel: HiDPIViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("HiDPI Configuration")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Optimize your display resolution for better visual quality")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // System Status Cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    StatusCard(
                        title: "System Status",
                        value: viewModel.systemStatus,
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                    
                    StatusCard(
                        title: "HiDPI Status",
                        value: viewModel.hidpiStatus,
                        icon: "display",
                        color: .blue
                    )
                    
                    StatusCard(
                        title: "Backup Status",
                        value: viewModel.backupStatus,
                        icon: "externaldrive.fill",
                        color: .orange
                    )
                }
                .padding(.horizontal)
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quick Actions")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 16) {
                        ActionButton(
                            title: "Auto Configure",
                            subtitle: "Detect and configure automatically",
                            icon: "wand.and.stars",
                            action: viewModel.autoConfigure
                        )
                        
                        ActionButton(
                            title: "Manual Setup",
                            subtitle: "Configure manually",
                            icon: "slider.horizontal.3",
                            action: viewModel.manualSetup
                        )
                        
                        ActionButton(
                            title: "Run Diagnostics",
                            subtitle: "Check system health",
                            icon: "stethoscope",
                            action: viewModel.runDiagnostics
                        )
                    }
                }
                .padding(.horizontal)
                
                // Recent Activity
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Activity")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    ForEach(viewModel.recentActivity, id: \.id) { activity in
                        ActivityRow(activity: activity)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.windowBackgroundColor))
        .onAppear {
            viewModel.loadSystemInfo()
        }
    }
}

struct StatusCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(12)
    }
}

struct ActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ActivityRow: View {
    let activity: ActivityItem
    
    var body: some View {
        HStack {
            Image(systemName: activity.icon)
                .foregroundColor(activity.color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Text(activity.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(activity.timestamp)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct MonitorConfigView: View {
    @ObservedObject var viewModel: HiDPIViewModel
    @State private var selectedResolution = "1920x1080"
    @State private var selectedIcon = "macbook"
    @State private var customMonitorName = ""
    
    let resolutions = [
        "1920x1080", "2560x1440", "3840x2160", "1366x768",
        "2560x1600", "3024x1964", "3456x2234", "3440x1440"
    ]
    
    let icons = [
        ("macbook", "MacBook"),
        ("macbookpro", "MacBook Pro"),
        ("imac", "iMac"),
        ("lg", "LG Display"),
        ("proxdr", "Pro Display XDR")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Monitor Configuration")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Configure HiDPI settings for your display")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Monitor Information
                VStack(alignment: .leading, spacing: 16) {
                    Text("Monitor Information")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 24) {
                        InfoCard(title: "Vendor ID", value: viewModel.vendorID)
                        InfoCard(title: "Product ID", value: viewModel.productID)
                        InfoCard(title: "Monitor Name", value: viewModel.monitorName)
                    }
                }
                .padding(.horizontal)
                
                // Configuration Options
                VStack(alignment: .leading, spacing: 16) {
                    Text("Configuration Options")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 16) {
                        // Resolution Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Resolution")
                                .font(.headline)
                            
                            Picker("Resolution", selection: $selectedResolution) {
                                ForEach(resolutions, id: \.self) { resolution in
                                    Text(resolution).tag(resolution)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: 200)
                        }
                        
                        // Icon Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Display Icon")
                                .font(.headline)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(icons, id: \.0) { icon in
                                    IconSelectionCard(
                                        icon: icon.0,
                                        title: icon.1,
                                        isSelected: selectedIcon == icon.0
                                    ) {
                                        selectedIcon = icon.0
                                    }
                                }
                            }
                        }
                        
                        // Custom Monitor Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Custom Monitor Name")
                                .font(.headline)
                            
                            TextField("Enter custom name (optional)", text: $customMonitorName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
                .padding(.horizontal)
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button("Apply Configuration") {
                        viewModel.applyConfiguration(
                            resolution: selectedResolution,
                            icon: selectedIcon,
                            customName: customMonitorName
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Reset to Defaults") {
                        viewModel.resetConfiguration()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.windowBackgroundColor))
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .cornerRadius(8)
    }
}

struct IconSelectionCard: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(isSelected ? .blue : .primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .blue : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : .regularMaterial)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// View Models and Data Structures
class HiDPIViewModel: ObservableObject {
    @Published var systemStatus = "Checking..."
    @Published var hidpiStatus = "Unknown"
    @Published var backupStatus = "Unknown"
    @Published var vendorID = "Unknown"
    @Published var productID = "Unknown"
    @Published var monitorName = "Unknown"
    @Published var recentActivity: [ActivityItem] = []
    
    func loadSystemInfo() {
        // Load system information from the bash script
        DispatchQueue.global(qos: .background).async {
            // Execute bash script to get system info
            let task = Process()
            task.launchPath = "/bin/bash"
            task.arguments = ["./hidpi.sh", "--info"]
            
            let pipe = Pipe()
            task.standardOutput = pipe
            
            do {
                try task.run()
                task.waitUntilExit()
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.parseSystemInfo(output)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.systemStatus = "Error loading system info"
                }
            }
        }
    }
    
    func parseSystemInfo(_ output: String) {
        // Parse the output from the bash script
        let lines = output.components(separatedBy: .newlines)
        
        for line in lines {
            if line.contains("Vendor ID:") {
                vendorID = line.components(separatedBy: ": ").last ?? "Unknown"
            } else if line.contains("Product ID:") {
                productID = line.components(separatedBy: ": ").last ?? "Unknown"
            } else if line.contains("Monitor Name:") {
                monitorName = line.components(separatedBy: ": ").last ?? "Unknown"
            }
        }
        
        systemStatus = "Ready"
        hidpiStatus = "Not configured"
        backupStatus = "No backups found"
    }
    
    func autoConfigure() {
        addActivity("Auto Configuration", "Starting automatic configuration...", "wand.and.stars", .blue)
        
        DispatchQueue.global(qos: .background).async {
            let task = Process()
            task.launchPath = "/bin/bash"
            task.arguments = ["./hidpi.sh", "--auto"]
            
            do {
                try task.run()
                task.waitUntilExit()
                
                DispatchQueue.main.async {
                    self.addActivity("Auto Configuration", "Configuration completed successfully", "checkmark.circle.fill", .green)
                    self.hidpiStatus = "Configured"
                }
            } catch {
                DispatchQueue.main.async {
                    self.addActivity("Auto Configuration", "Configuration failed", "xmark.circle.fill", .red)
                }
            }
        }
    }
    
    func manualSetup() {
        addActivity("Manual Setup", "Opening manual configuration...", "slider.horizontal.3", .orange)
    }
    
    func runDiagnostics() {
        addActivity("Diagnostics", "Running system diagnostics...", "stethoscope", .purple)
        
        DispatchQueue.global(qos: .background).async {
            let task = Process()
            task.launchPath = "/bin/bash"
            task.arguments = ["./hidpi.sh", "--diagnostics"]
            
            do {
                try task.run()
                task.waitUntilExit()
                
                DispatchQueue.main.async {
                    self.addActivity("Diagnostics", "Diagnostics completed", "checkmark.circle.fill", .green)
                }
            } catch {
                DispatchQueue.main.async {
                    self.addActivity("Diagnostics", "Diagnostics failed", "xmark.circle.fill", .red)
                }
            }
        }
    }
    
    func applyConfiguration(resolution: String, icon: String, customName: String) {
        addActivity("Configuration", "Applying configuration...", "gear", .blue)
        
        DispatchQueue.global(qos: .background).async {
            let task = Process()
            task.launchPath = "/bin/bash"
            task.arguments = ["./hidpi.sh", "--configure", resolution, icon, customName]
            
            do {
                try task.run()
                task.waitUntilExit()
                
                DispatchQueue.main.async {
                    self.addActivity("Configuration", "Configuration applied successfully", "checkmark.circle.fill", .green)
                    self.hidpiStatus = "Configured"
                }
            } catch {
                DispatchQueue.main.async {
                    self.addActivity("Configuration", "Configuration failed", "xmark.circle.fill", .red)
                }
            }
        }
    }
    
    func resetConfiguration() {
        addActivity("Reset", "Resetting configuration...", "arrow.clockwise", .orange)
        
        DispatchQueue.global(qos: .background).async {
            let task = Process()
            task.launchPath = "/bin/bash"
            task.arguments = ["./hidpi.sh", "--reset"]
            
            do {
                try task.run()
                task.waitUntilExit()
                
                DispatchQueue.main.async {
                    self.addActivity("Reset", "Configuration reset successfully", "checkmark.circle.fill", .green)
                    self.hidpiStatus = "Not configured"
                }
            } catch {
                DispatchQueue.main.async {
                    self.addActivity("Reset", "Reset failed", "xmark.circle.fill", .red)
                }
            }
        }
    }
    
    private func addActivity(_ title: String, _ description: String, _ icon: String, _ color: Color) {
        let activity = ActivityItem(
            title: title,
            description: description,
            icon: icon,
            color: color,
            timestamp: Date().formatted(date: .abbreviated, time: .shortened)
        )
        
        DispatchQueue.main.async {
            self.recentActivity.insert(activity, at: 0)
            if self.recentActivity.count > 10 {
                self.recentActivity.removeLast()
            }
        }
    }
}

struct ActivityItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let timestamp: String
}

// Placeholder views for other tabs
struct BackupView: View {
    @ObservedObject var viewModel: HiDPIViewModel
    
    var body: some View {
        VStack {
            Text("Backup & Restore")
                .font(.largeTitle)
            Text("Coming soon...")
                .foregroundColor(.secondary)
        }
    }
}

struct DiagnosticsView: View {
    @ObservedObject var viewModel: HiDPIViewModel
    
    var body: some View {
        VStack {
            Text("System Diagnostics")
                .font(.largeTitle)
            Text("Coming soon...")
                .foregroundColor(.secondary)
        }
    }
}

struct SettingsView: View {
    @ObservedObject var viewModel: HiDPIViewModel
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
            Text("Coming soon...")
                .foregroundColor(.secondary)
        }
    }
}
