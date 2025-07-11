library(shiny)

# Initialize empty data
full_data <- NULL
original_data <- NULL
date_col <- NULL

ui <- fluidPage(
  tags$head(
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"),
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
      
      * {
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      }
      
      body {
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
        background-size: 400% 400%;
        animation: gradientShift 8s ease infinite;
        margin: 0;
        padding: 0;
        min-height: 100vh;
      }
      
      @keyframes gradientShift {
        0% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
        100% { background-position: 0% 50%; }
      }
      
      .container-fluid {
        background: transparent;
        padding: 0;
      }
      
      .main-title-container {
        background: transparent;
        padding: 60px 0 40px 0;
        margin: 0 0 40px 0;
        text-align: center;
        position: relative;
        overflow: hidden;
      }
      
      .main-title {
        color: white;
        font-size: 4.5em;
        font-weight: 700;
        margin: 0 0 60px 0;
        text-shadow: 0 4px 20px rgba(0,0,0,0.3);
        letter-spacing: -0.02em;
        position: relative;
        z-index: 1;
        background: linear-gradient(45deg, #ffffff, #f0f8ff, #ffffff);
        background-size: 200% 200%;
        animation: titleShimmer 3s ease infinite;
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
      }
      
      @keyframes titleShimmer {
        0% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
        100% { background-position: 0% 50%; }
      }
      
      .features-container {
        max-width: 800px;
        margin: 0 auto 60px auto;
        padding: 0 40px;
      }
      
      .feature-item {
        display: flex;
        align-items: flex-start;
        margin-bottom: 25px;
        opacity: 0;
        transform: translateX(-30px);
        animation: slideInLeft 0.8s ease forwards;
      }
      
      .feature-item:nth-child(1) { animation-delay: 0.2s; }
      .feature-item:nth-child(2) { animation-delay: 0.4s; }
      .feature-item:nth-child(3) { animation-delay: 0.6s; }
      .feature-item:nth-child(4) { animation-delay: 0.8s; }
      .feature-item:nth-child(5) { animation-delay: 1.0s; }
      .feature-item:nth-child(6) { animation-delay: 1.2s; }
      
      @keyframes slideInLeft {
        to {
          opacity: 1;
          transform: translateX(0);
        }
      }
      
      .bullet-point {
        width: 12px;
        height: 12px;
        background: linear-gradient(45deg, #ffffff, #e3f2fd);
        border-radius: 50%;
        margin-right: 20px;
        margin-top: 6px;
        box-shadow: 0 2px 8px rgba(255, 255, 255, 0.3);
        animation: pulse 2s ease infinite;
        flex-shrink: 0;
      }
      
      @keyframes pulse {
        0%, 100% { transform: scale(1); box-shadow: 0 2px 8px rgba(255, 255, 255, 0.3); }
        50% { transform: scale(1.1); box-shadow: 0 4px 15px rgba(255, 255, 255, 0.5); }
      }
      
      .feature-text {
        color: white;
        font-size: 18px;
        font-weight: 400;
        line-height: 1.6;
        text-shadow: 0 2px 8px rgba(0,0,0,0.2);
        letter-spacing: 0.3px;
      }
      
      .start-button-container {
        text-align: center;
        margin: 80px 0 60px 0;
      }
      
      .start-btn {
        min-width: 200px;
        height: 70px;
        font-size: 20px;
        font-weight: 700;
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        border: none;
        border-radius: 35px;
        color: white;
        cursor: pointer;
        position: relative;
        overflow: hidden;
        box-shadow: 0 10px 30px rgba(79, 172, 254, 0.4);
        transform: translateY(0);
        letter-spacing: 1px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      }
      
      .start-btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
        transition: left 0.6s;
      }
      
      .start-btn:hover {
        transform: translateY(-6px);
        box-shadow: 0 20px 40px rgba(79, 172, 254, 0.6);
        background: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
      }
      
      .start-btn:hover::before {
        left: 100%;
      }
      
      .start-btn:active {
        transform: translateY(-3px);
        box-shadow: 0 15px 30px rgba(79, 172, 254, 0.5);
      }
      
      .page-title-container {
        background: transparent;
        padding: 60px 0 40px 0;
        margin: 0 0 40px 0;
        text-align: center;
        position: relative;
        overflow: hidden;
      }
      
      .page-title {
        color: white;
        font-size: 3.5em;
        font-weight: 700;
        margin: 0 0 20px 0;
        text-shadow: 0 4px 20px rgba(0,0,0,0.3);
        letter-spacing: -0.02em;
        position: relative;
        z-index: 1;
        background: linear-gradient(45deg, #ffffff, #e3f2fd, #ffffff);
        background-size: 200% 200%;
        animation: titleShimmer 3s ease infinite;
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        opacity: 0;
        transform: translateY(-30px);
        animation: fadeInTitle 1s ease forwards, titleShimmer 3s ease infinite;
      }
      
      @keyframes fadeInTitle {
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
      
      .main-title, .page-title {
        color: white;
        font-size: 3.5em;
        font-weight: 700;
        margin: 0;
        text-shadow: 0 4px 8px rgba(0,0,0,0.2);
        letter-spacing: -0.02em;
        position: relative;
        z-index: 1;
      }
      
      .content-card {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        border-radius: 25px;
        padding: 40px;
        margin: 20px;
        box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
        border: 1px solid rgba(255, 255, 255, 0.3);
        animation: slideInUp 0.8s cubic-bezier(0.4, 0, 0.2, 1);
        position: relative;
        overflow: hidden;
      }
      
      .content-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
        animation: cardShimmer 4s ease infinite;
      }
      
      @keyframes cardShimmer {
        0% { left: -100%; }
        100% { left: 100%; }
      }
      
      @keyframes slideInUp {
        from {
          opacity: 0;
          transform: translateY(50px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
      
      .charts-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
        gap: 30px;
        margin: 40px 0;
        animation: chartsSlideIn 1s ease-out 0.8s both;
      }
      
      @keyframes chartsSlideIn {
        from {
          opacity: 0;
          transform: translateY(40px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
      
      .chart-card {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.4);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        position: relative;
        overflow: hidden;
        opacity: 0;
        animation: chartCardReveal 0.8s ease-out forwards;
      }
      
      .chart-card:nth-child(1) { animation-delay: 1.0s; }
      .chart-card:nth-child(2) { animation-delay: 1.2s; }
      .chart-card:nth-child(3) { animation-delay: 1.4s; }
      .chart-card:nth-child(4) { animation-delay: 1.6s; }
      
      @keyframes chartCardReveal {
        to {
          opacity: 1;
        }
      }
      
      .chart-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(79, 172, 254, 0.1), transparent);
        animation: chartShimmer 3s ease infinite;
      }
      
      @keyframes chartShimmer {
        0% { left: -100%; }
        100% { left: 100%; }
      }
      
      .chart-card:hover {
        transform: translateY(-5px) scale(1.02);
        box-shadow: 0 25px 60px rgba(0, 0, 0, 0.15);
      }
      
      .chart-title {
        font-size: 18px;
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 15px;
        text-align: center;
        letter-spacing: 0.3px;
      }
      
      .chart-canvas {
        max-height: 300px;
        width: 100%;
      }
      
      .file-input-container {
        display: flex;
        justify-content: flex-start;
        margin: 30px 0;
        animation: fadeInLeft 1s ease-out 0.3s both;
      }
      
      @keyframes fadeInLeft {
        from {
          opacity: 0;
          transform: translateX(-30px);
        }
        to {
          opacity: 1;
          transform: translateX(0);
        }
      }
      
      .file-input-large {
        width: 100%;
        max-width: 500px;
        position: relative;
      }
      
      .file-input-large .form-group {
        margin-bottom: 0;
      }
      
      .file-input-large label {
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 15px;
        display: block;
        color: #2c3e50;
        letter-spacing: 0.3px;
        animation: fadeIn 1.2s ease-out 0.5s both;
      }
      
      .file-input-large input[type='file'] {
        font-size: 16px;
        padding: 25px;
        height: 80px;
        width: 100%;
        border: 3px dashed #ddd;
        border-radius: 20px;
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        cursor: pointer;
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        font-weight: 500;
        position: relative;
        overflow: hidden;
      }
      
      .file-input-large input[type='file']:hover {
        border-color: #4facfe;
        background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
        transform: translateY(-3px) scale(1.02);
        box-shadow: 0 15px 40px rgba(79, 172, 254, 0.3);
      }
      
      .file-input-large input[type='file']:focus {
        outline: none;
        border-color: #00f2fe;
        box-shadow: 0 0 0 6px rgba(79, 172, 254, 0.15);
      }
      
      .date-input-container {
        display: flex;
        align-items: center;
        gap: 25px;
        margin: 30px 0;
        flex-wrap: wrap;
        animation: fadeInUp 1s ease-out 0.6s both;
      }
      
      @keyframes fadeInUp {
        from {
          opacity: 0;
          transform: translateY(30px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
      
      .date-input-large {
        flex: 1;
        min-width: 200px;
        position: relative;
        overflow: hidden;
        border-radius: 15px;
        background: linear-gradient(135deg, rgba(255,255,255,0.8) 0%, rgba(240,248,255,0.9) 100%);
        padding: 20px;
        transition: all 0.3s ease;
      }
      
      .date-input-large:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 30px rgba(79, 172, 254, 0.2);
      }
      
      .date-input-large label {
        font-size: 16px;
        font-weight: 600;
        margin-bottom: 10px;
        color: #2c3e50;
        letter-spacing: 0.3px;
        display: block;
      }
      
      .date-input-large input {
        font-size: 16px;
        padding: 15px;
        height: 55px;
        width: 100%;
        border: 2px solid rgba(79, 172, 254, 0.3);
        border-radius: 12px;
        background: white;
        font-weight: 500;
        transition: all 0.3s ease;
      }
      
      .date-input-large input:hover {
        border-color: #4facfe;
        box-shadow: 0 4px 15px rgba(79, 172, 254, 0.2);
      }
      
      .date-input-large input:focus {
        outline: none;
        border-color: #00f2fe;
        box-shadow: 0 0 0 4px rgba(79, 172, 254, 0.1);
      }
      
      .generate-summary-container {
        text-align: center;
        margin: 40px 0 20px 0;
        animation: fadeInScale 1s ease-out 1.2s both;
      }
      
      @keyframes fadeInScale {
        from {
          opacity: 0;
          transform: scale(0.8);
        }
        to {
          opacity: 1;
          transform: scale(1);
        }
      }
      
      .generate-summary-btn {
        min-width: 220px;
        height: 60px;
        font-size: 18px;
        font-weight: 600;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        border-radius: 30px;
        color: white;
        cursor: pointer;
        position: relative;
        overflow: hidden;
        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        transform: translateY(0);
        letter-spacing: 0.5px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      }
      
      .generate-summary-btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
        transition: left 0.6s;
      }
      
      .generate-summary-btn:hover {
        transform: translateY(-4px);
        box-shadow: 0 15px 35px rgba(102, 126, 234, 0.6);
        background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
      }
      
      .generate-summary-btn:hover::before {
        left: 100%;
      }
      
      .generate-summary-btn:active {
        transform: translateY(-2px);
        box-shadow: 0 10px 25px rgba(102, 126, 234, 0.5);
      }
      
      .btn-secondary {
        background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
        border: none;
        border-radius: 12px;
        padding: 12px 25px;
        color: white;
        font-weight: 600;
        font-size: 16px;
        cursor: pointer;
        transition: all 0.3s ease;
        letter-spacing: 0.3px;
      }
      
      .btn-secondary:hover {
        background: linear-gradient(135deg, #495057 0%, #6c757d 100%);
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(108, 117, 125, 0.3);
      }
      
      .btn-info {
        background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
        border: none;
        border-radius: 12px;
        padding: 12px 25px;
        color: white;
        font-weight: 600;
        font-size: 16px;
        cursor: pointer;
        transition: all 0.3s ease;
        letter-spacing: 0.3px;
      }
      
      .chart-canvas {
        max-height: 300px;
        width: 100%;
        position: relative;
        z-index: 1;
      }
      
      .text-data {
        background: linear-gradient(135deg, rgba(248,249,250,0.9) 0%, rgba(233,236,239,0.9) 100%);
        border-radius: 20px;
        padding: 30px;
        border: 1px solid rgba(255, 255, 255, 0.3);
        font-family: 'SF Mono', 'Monaco', 'Cascadia Code', monospace;
        font-size: 14px;
        line-height: 1.7;
        color: #2c3e50;
        box-shadow: inset 0 4px 12px rgba(0, 0, 0, 0.08);
        animation: textDataSlide 1s ease-out 0.9s both;
        max-height: 400px;
        overflow-y: auto;
        margin: 25px 0;
        position: relative;
        backdrop-filter: blur(10px);
      }
      
      .text-data::-webkit-scrollbar {
        width: 8px;
      }
      
      .text-data::-webkit-scrollbar-track {
        background: rgba(0, 0, 0, 0.05);
        border-radius: 4px;
      }
      
      .text-data::-webkit-scrollbar-thumb {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        border-radius: 4px;
      }
      
      .text-data::-webkit-scrollbar-thumb:hover {
        background: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
      }
      
      .shiny-notification {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        border: none;
        border-radius: 15px;
        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
        font-weight: 500;
        letter-spacing: 0.3px;
        animation: notificationSlideIn 0.5s ease-out;
      }
      
      @keyframes notificationSlideIn {
        from {
          opacity: 0;
          transform: translateY(-20px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
      
      .shiny-notification-content {
        padding: 15px 20px;
      }
      
      @keyframes fadeIn {
        from {
          opacity: 0;
        }
        to {
          opacity: 1;
        }
      }
      
      .text-data {
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        border-radius: 15px;
        padding: 25px;
        border: none;
        font-family: 'SF Mono', 'Monaco', 'Cascadia Code', monospace;
        font-size: 14px;
        line-height: 1.6;
        color: #2c3e50;
        box-shadow: inset 0 2px 8px rgba(0, 0, 0, 0.05);
        animation: fadeIn 0.8s ease-out 0.6s both;
        max-height: 400px;
        overflow-y: auto;
        margin: 20px 0;
      }
      
      .text-data::-webkit-scrollbar {
        width: 8px;
      }
      
      .text-data::-webkit-scrollbar-track {
        background: rgba(0, 0, 0, 0.05);
        border-radius: 4px;
      }
      
      .text-data::-webkit-scrollbar-thumb {
        background: rgba(52, 152, 219, 0.3);
        border-radius: 4px;
      }
      
      .text-data::-webkit-scrollbar-thumb:hover {
        background: rgba(52, 152, 219, 0.5);
      }
      
      .shiny-notification {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        border: none;
        border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        font-weight: 500;
        letter-spacing: 0.3px;
      }
      
      .shiny-notification-content {
        padding: 15px 20px;
      }
      
      @media (max-width: 768px) {
        .main-title {
          font-size: 3em;
        }
        
        .page-title {
          font-size: 2.5em;
        }
        
        .features-container {
          padding: 0 20px;
        }
        
        .feature-text {
          font-size: 16px;
        }
        
        .start-btn {
          min-width: 180px;
          height: 60px;
          font-size: 18px;
        }
        
        .generate-summary-btn {
          min-width: 200px;
          height: 55px;
          font-size: 16px;
        }
        
        .content-card {
          margin: 10px;
          padding: 25px;
        }
        
        .date-input-container {
          flex-direction: column;
          gap: 15px;
        }
        
        .charts-container {
          grid-template-columns: 1fr;
          gap: 20px;
        }
        
        .file-input-large input[type='file'] {
          height: 70px;
          padding: 20px;
        }
      }
    "))
  ),
  uiOutput("main_ui")
)

server <- function(input, output, session) {
  page <- reactiveVal("main")
  previous_page <- reactiveVal("main")
  
  # Function to process uploaded CSV
  process_csv <- function(file_path) {
    tryCatch({
      # Read the CSV
      original_data <<- read.csv(file_path, stringsAsFactors = FALSE)
      full_data <<- original_data
      
      # Find date column
      date_col <<- NULL
      for(col in names(full_data)) {
        if(grepl("date|Date|DATE", col, ignore.case = TRUE)) {
          date_col <<- col
          break
        }
      }
      
      # If no date column found, check first column
      if(is.null(date_col)) {
        date_col <<- names(full_data)[1]
      }
      
      # Parse dates
      full_data$Date <<- tryCatch({
        # Try M/D/YYYY format first
        parsed <- as.Date(full_data[[date_col]], format = "%m/%d/%Y")
        if(all(is.na(parsed))) {
          # Try M/D/YY format
          parsed <- as.Date(full_data[[date_col]], format = "%m/%d/%y")
        }
        if(all(is.na(parsed))) {
          # Try YYYY-MM-DD format
          parsed <- as.Date(full_data[[date_col]], format = "%Y-%m-%d")
        }
        if(all(is.na(parsed))) {
          # Try automatic parsing
          parsed <- as.Date(full_data[[date_col]])
        }
        parsed
      }, error = function(e) {
        rep(NA, nrow(full_data))
      })
      
      return(TRUE)
    }, error = function(e) {
      showNotification(paste("Error reading CSV:", e$message), type = "error")
      return(FALSE)
    })
  }
  
  # Function to generate interactive charts for all data types
  generate_interactive_charts <- function(df, output_id) {
    if(nrow(df) == 0) return("")
    
    chart_id_hr <- paste0("heartRate_", output_id)
    chart_id_sleep <- paste0("sleep_", output_id) 
    chart_id_activity <- paste0("activity_", output_id)
    chart_id_breathing <- paste0("breathing_", output_id)
    
    charts_html <- '<div class="charts-container">'
    
    # Heart Rate Chart
    hr_cols_exist <- any(c("hr_avg", "hr_min", "hr_max") %in% names(df))
    if(hr_cols_exist && !all(is.na(df$hr_avg))) {
      charts_html <- paste0(charts_html,
                            '<div class="chart-card">',
                            '<div class="chart-title">💓 Heart Rate Trends</div>',
                            '<canvas id="', chart_id_hr, '" class="chart-canvas"></canvas>',
                            '</div>'
      )
    }
    
    # Sleep Chart
    sleep_cols <- c("sleep_total", "sleep_light", "sleep_deep", "sleep_rem")
    existing_sleep_cols <- sleep_cols[sleep_cols %in% names(df)]
    sleep_has_data <- FALSE
    
    if(length(existing_sleep_cols) > 0) {
      for(col in existing_sleep_cols) {
        if(!all(is.na(df[[col]]))) {
          sleep_has_data <- TRUE
          break
        }
      }
    }
    
    if(sleep_has_data) {
      charts_html <- paste0(charts_html,
                            '<div class="chart-card">',
                            '<div class="chart-title">😴 Sleep Analysis</div>',
                            '<canvas id="', chart_id_sleep, '" class="chart-canvas"></canvas>',
                            '</div>'
      )
    }
    
    # Activity Chart
    if("act_cat" %in% names(df) && !all(is.na(df$act_cat))) {
      charts_html <- paste0(charts_html,
                            '<div class="chart-card">',
                            '<div class="chart-title">📊 Activity Categories</div>',
                            '<canvas id="', chart_id_activity, '" class="chart-canvas"></canvas>',
                            '</div>'
      )
    }
    
    # Breathing Chart
    if("br_avg" %in% names(df) && !all(is.na(df$br_avg))) {
      charts_html <- paste0(charts_html,
                            '<div class="chart-card">',
                            '<div class="chart-title">🫁 Breathing Rate</div>',
                            '<canvas id="', chart_id_breathing, '" class="chart-canvas"></canvas>',
                            '</div>'
      )
    }
    
    charts_html <- paste0(charts_html, '</div>')
    
    # Add JavaScript for charts
    charts_html <- paste0(charts_html, '<script>')
    
    hr_cols_exist <- any(c("hr_avg", "hr_min", "hr_max") %in% names(df))
    if(hr_cols_exist && !all(is.na(df$hr_avg))) {
      charts_html <- paste0(charts_html, create_heart_rate_js(df, chart_id_hr))
    }
    
    # Check for sleep data more comprehensively
    sleep_cols <- c("sleep_total", "sleep_light", "sleep_deep", "sleep_rem")
    existing_sleep_cols <- sleep_cols[sleep_cols %in% names(df)]
    sleep_has_data <- FALSE
    
    if(length(existing_sleep_cols) > 0) {
      for(col in existing_sleep_cols) {
        if(!all(is.na(df[[col]]))) {
          sleep_has_data <- TRUE
          break
        }
      }
    }
    
    if(sleep_has_data) {
      charts_html <- paste0(charts_html, create_sleep_js(df, chart_id_sleep))
    }
    
    if("act_cat" %in% names(df) && !all(is.na(df$act_cat))) {
      charts_html <- paste0(charts_html, create_activity_js(df, chart_id_activity))
    }
    
    if("br_avg" %in% names(df) && !all(is.na(df$br_avg))) {
      charts_html <- paste0(charts_html, create_breathing_js(df, chart_id_breathing))
    }
    
    charts_html <- paste0(charts_html, '</script>')
    
    return(charts_html)
  }
  
  # Heart Rate Interactive Chart JavaScript
  create_heart_rate_js <- function(df, chart_id) {
    # Check if heart rate columns exist
    hr_cols_exist <- any(c("hr_avg", "hr_min", "hr_max") %in% names(df))
    if(!hr_cols_exist) return("")
    
    valid_data <- df[!is.na(df$hr_avg), ]
    if(nrow(valid_data) == 0) return("")
    
    # Sample data if too many points for better visualization
    if(nrow(valid_data) > 50) {
      # Take every nth point to reduce clutter
      sample_interval <- ceiling(nrow(valid_data) / 50)
      valid_data <- valid_data[seq(1, nrow(valid_data), by = sample_interval), ]
    }
    
    dates <- format(valid_data$Date, "%m-%d")
    
    # Handle missing HR columns with defaults
    hr_min <- if("hr_min" %in% names(valid_data)) valid_data$hr_min else valid_data$hr_avg
    hr_max <- if("hr_max" %in% names(valid_data)) valid_data$hr_max else valid_data$hr_avg
    hr_avg <- valid_data$hr_avg
    
    # Replace NAs with average where possible
    hr_min[is.na(hr_min)] <- hr_avg[is.na(hr_min)]
    hr_max[is.na(hr_max)] <- hr_avg[is.na(hr_max)]
    
    # Create safe JavaScript arrays
    labels_js <- paste0('["', paste(dates, collapse = '","'), '"]')
    min_js <- paste0('[', paste(hr_min, collapse = ','), ']')
    max_js <- paste0('[', paste(hr_max, collapse = ','), ']')
    avg_js <- paste0('[', paste(hr_avg, collapse = ','), ']')
    
    js_code <- paste0(
      'setTimeout(function() {
        var ctx = document.getElementById("', chart_id, '");
        if(ctx && typeof Chart !== "undefined") {
          new Chart(ctx, {
            type: "line",
            data: {
              labels: ', labels_js, ',
              datasets: [{
                label: "Min HR",
                data: ', min_js, ',
                borderColor: "#3498db",
                backgroundColor: "rgba(52, 152, 219, 0.1)",
                fill: false,
                tension: 0.4,
                borderWidth: 2,
                pointRadius: function(context) {
                  return context.chart.data.labels.length > 30 ? 0 : 3;
                },
                pointHoverRadius: 5
              }, {
                label: "Average HR", 
                data: ', avg_js, ',
                borderColor: "#e74c3c",
                backgroundColor: "rgba(231, 76, 60, 0.1)",
                fill: false,
                tension: 0.4,
                borderWidth: 3,
                pointRadius: function(context) {
                  return context.chart.data.labels.length > 30 ? 0 : 4;
                },
                pointHoverRadius: 6
              }, {
                label: "Max HR",
                data: ', max_js, ',
                borderColor: "#f39c12",
                backgroundColor: "rgba(243, 156, 18, 0.1)",
                fill: false,
                tension: 0.4,
                borderWidth: 2,
                pointRadius: function(context) {
                  return context.chart.data.labels.length > 30 ? 0 : 3;
                },
                pointHoverRadius: 5
              }]
            },
            options: {
              responsive: true,
              maintainAspectRatio: false,
              interaction: {
                intersect: false,
                mode: "index"
              },
              plugins: {
                legend: {
                  position: "top"
                },
                tooltip: {
                  mode: "index",
                  intersect: false,
                  callbacks: {
                    title: function(context) {
                      return "Date: " + context[0].label;
                    },
                    label: function(context) {
                      return context.dataset.label + ": " + context.parsed.y + " BPM";
                    }
                  }
                }
              },
              scales: {
                x: {
                  display: true,
                  title: {
                    display: true,
                    text: "Date"
                  },
                  ticks: {
                    maxTicksLimit: 10,
                    autoSkip: true,
                    maxRotation: 45
                  }
                },
                y: {
                  display: true,
                  title: {
                    display: true,
                    text: "BPM"
                  },
                  beginAtZero: false
                }
              }
            }
          });
        }
      }, 500);'
    )
    
    return(js_code)
  }
  
  # Sleep Interactive Chart JavaScript
  create_sleep_js <- function(df, chart_id) {
    # Check if any sleep columns exist
    sleep_cols <- c("sleep_total", "sleep_light", "sleep_deep", "sleep_rem")
    existing_sleep_cols <- sleep_cols[sleep_cols %in% names(df)]
    
    if(length(existing_sleep_cols) == 0) return("")
    
    # If we have sleep_total but no breakdown, use sleep_total
    if("sleep_total" %in% names(df)) {
      valid_data <- df[!is.na(df$sleep_total), ]
    } else {
      # Otherwise use any available sleep data
      valid_data <- df
      for(col in existing_sleep_cols) {
        valid_data <- valid_data[!is.na(valid_data[[col]]), ]
      }
    }
    
    if(nrow(valid_data) == 0) return("")
    
    # Sample data if too many points for better visualization
    if(nrow(valid_data) > 50) {
      # Take every nth point to reduce clutter
      sample_interval <- ceiling(nrow(valid_data) / 50)
      valid_data <- valid_data[seq(1, nrow(valid_data), by = sample_interval), ]
    }
    
    dates <- format(valid_data$Date, "%m-%d")
    
    # Handle missing sleep columns with defaults
    if("sleep_light" %in% names(valid_data)) {
      sleep_light <- valid_data$sleep_light
      sleep_light[is.na(sleep_light)] <- 0
    } else if("sleep_total" %in% names(valid_data)) {
      sleep_light <- valid_data$sleep_total * 0.6  # Assume 60% light sleep
    } else {
      sleep_light <- rep(0, nrow(valid_data))
    }
    
    if("sleep_deep" %in% names(valid_data)) {
      sleep_deep <- valid_data$sleep_deep
      sleep_deep[is.na(sleep_deep)] <- 0
    } else if("sleep_total" %in% names(valid_data)) {
      sleep_deep <- valid_data$sleep_total * 0.25  # Assume 25% deep sleep
    } else {
      sleep_deep <- rep(0, nrow(valid_data))
    }
    
    if("sleep_rem" %in% names(valid_data)) {
      sleep_rem <- valid_data$sleep_rem
      sleep_rem[is.na(sleep_rem)] <- 0
    } else if("sleep_total" %in% names(valid_data)) {
      sleep_rem <- valid_data$sleep_total * 0.15  # Assume 15% REM sleep
    } else {
      sleep_rem <- rep(0, nrow(valid_data))
    }
    
    # Create safe JavaScript arrays
    labels_js <- paste0('["', paste(dates, collapse = '","'), '"]')
    light_js <- paste0('[', paste(sleep_light, collapse = ','), ']')
    deep_js <- paste0('[', paste(sleep_deep, collapse = ','), ']')
    rem_js <- paste0('[', paste(sleep_rem, collapse = ','), ']')
    
    js_code <- paste0(
      'setTimeout(function() {
        var ctx = document.getElementById("', chart_id, '");
        if(ctx && typeof Chart !== "undefined") {
          new Chart(ctx, {
            type: "bar",
            data: {
              labels: ', labels_js, ',
              datasets: [{
                label: "Light Sleep",
                data: ', light_js, ',
                backgroundColor: "#3498db",
                borderRadius: 5,
                borderSkipped: false
              }, {
                label: "Deep Sleep",
                data: ', deep_js, ',
                backgroundColor: "#2c3e50",
                borderRadius: 5,
                borderSkipped: false
              }, {
                label: "REM Sleep",
                data: ', rem_js, ',
                backgroundColor: "#9b59b6",
                borderRadius: 5,
                borderSkipped: false
              }]
            },
            options: {
              responsive: true,
              maintainAspectRatio: false,
              interaction: {
                intersect: false,
                mode: "index"
              },
              plugins: {
                legend: {
                  position: "top"
                },
                tooltip: {
                  mode: "index",
                  intersect: false,
                  callbacks: {
                    title: function(context) {
                      return "Date: " + context[0].label;
                    },
                    label: function(context) {
                      return context.dataset.label + ": " + context.parsed.y.toFixed(1) + " hours";
                    }
                  }
                }
              },
              scales: {
                x: {
                  stacked: true,
                  title: {
                    display: true,
                    text: "Date"
                  },
                  ticks: {
                    maxTicksLimit: 15,
                    autoSkip: true,
                    maxRotation: 45
                  }
                },
                y: {
                  stacked: true,
                  title: {
                    display: true,
                    text: "Hours"
                  },
                  beginAtZero: true
                }
              }
            }
          });
        }
      }, 600);'
    )
    
    return(js_code)
  }
  
  # Activity Interactive Chart JavaScript
  create_activity_js <- function(df, chart_id) {
    # Check if activity column exists
    if(!"act_cat" %in% names(df)) return("")
    
    activities <- table(df$act_cat[!is.na(df$act_cat) & df$act_cat != ""])
    if(length(activities) == 0) return("")
    
    # Create safe JavaScript arrays
    labels_js <- paste0('["', paste(names(activities), collapse = '","'), '"]')
    data_js <- paste0('[', paste(as.numeric(activities), collapse = ','), ']')
    
    # Generate colors for each category
    colors <- c("#e74c3c", "#3498db", "#2ecc71", "#f39c12", "#9b59b6", "#1abc9c", "#34495e", "#e67e22", "#16a085", "#8e44ad")
    colors_needed <- min(length(activities), length(colors))
    colors_js <- paste0('["', paste(colors[1:colors_needed], collapse = '","'), '"]')
    
    js_code <- paste0(
      'setTimeout(function() {
        var ctx = document.getElementById("', chart_id, '");
        if(ctx && typeof Chart !== "undefined") {
          new Chart(ctx, {
            type: "doughnut",
            data: {
              labels: ', labels_js, ',
              datasets: [{
                data: ', data_js, ',
                backgroundColor: ', colors_js, ',
                borderWidth: 2,
                borderColor: "#fff",
                hoverOffset: 10,
                hoverBorderWidth: 3
              }]
            },
            options: {
              responsive: true,
              maintainAspectRatio: false,
              plugins: {
                legend: {
                  position: "bottom",
                  labels: {
                    padding: 20,
                    usePointStyle: true
                  }
                },
                tooltip: {
                  callbacks: {
                    label: function(context) {
                      var total = context.dataset.data.reduce(function(a, b) { return a + b; }, 0);
                      var percentage = Math.round((context.parsed / total) * 100);
                      return context.label + ": " + context.parsed + " (" + percentage + "%)";
                    }
                  }
                }
              }
            }
          });
        }
      }, 700);'
    )
    
    return(js_code)
  }
  
  # Breathing Interactive Chart JavaScript
  create_breathing_js <- function(df, chart_id) {
    # Check if breathing column exists
    if(!"br_avg" %in% names(df)) return("")
    
    valid_data <- df[!is.na(df$br_avg), ]
    if(nrow(valid_data) == 0) return("")
    
    # Sample data if too many points for better visualization
    if(nrow(valid_data) > 50) {
      # Take every nth point to reduce clutter
      sample_interval <- ceiling(nrow(valid_data) / 50)
      valid_data <- valid_data[seq(1, nrow(valid_data), by = sample_interval), ]
    }
    
    dates <- format(valid_data$Date, "%m-%d")
    br_avg <- valid_data$br_avg
    
    # Create safe JavaScript arrays
    labels_js <- paste0('["', paste(dates, collapse = '","'), '"]')
    data_js <- paste0('[', paste(br_avg, collapse = ','), ']')
    
    js_code <- paste0(
      'setTimeout(function() {
        var ctx = document.getElementById("', chart_id, '");
        if(ctx && typeof Chart !== "undefined") {
          new Chart(ctx, {
            type: "line",
            data: {
              labels: ', labels_js, ',
              datasets: [{
                label: "Breathing Rate",
                data: ', data_js, ',
                borderColor: "#1abc9c",
                backgroundColor: "rgba(26, 188, 156, 0.1)",
                fill: true,
                tension: 0.4,
                borderWidth: 3,
                pointBackgroundColor: "#1abc9c",
                pointBorderColor: "#fff",
                pointBorderWidth: 2,
                pointRadius: function(context) {
                  return context.chart.data.labels.length > 30 ? 0 : 4;
                },
                pointHoverRadius: 8
              }]
            },
            options: {
              responsive: true,
              maintainAspectRatio: false,
              interaction: {
                intersect: false,
                mode: "index"
              },
              plugins: {
                legend: {
                  display: false
                },
                tooltip: {
                  mode: "index",
                  intersect: false,
                  callbacks: {
                    title: function(context) {
                      return "Date: " + context[0].label;
                    },
                    label: function(context) {
                      return "Breathing Rate: " + context.parsed.y + " breaths/min";
                    }
                  }
                }
              },
              scales: {
                x: {
                  title: {
                    display: true,
                    text: "Date"
                  },
                  ticks: {
                    maxTicksLimit: 10,
                    autoSkip: true,
                    maxRotation: 45
                  }
                },
                y: {
                  title: {
                    display: true,
                    text: "Breaths/min"
                  },
                  beginAtZero: true
                }
              }
            }
          });
        }
      }, 800);'
    )
    
    return(js_code)
  }
  
  output$main_ui <- renderUI({
    switch(page(),
           "main" = mainPageUI(),
           "custom" = customPageUI(),
           "alldata" = allDataPageUI()
    )
  })
  
  mainPageUI <- function() {
    tagList(
      div(class = "main-title-container",
          div(class = "main-title", "NCHacks Pulspanion"),
          div(class = "features-container",
              div(class = "feature-item",
                  div(class = "bullet-point"),
                  div(class = "feature-text", "Track, analyze, and visualize heart rate and wellness data in real time")
              ),
              div(class = "feature-item",
                  div(class = "bullet-point"),
                  div(class = "feature-text", "Monitor daily vitals, manage conditions, or optimize fitness performance")
              ),
              div(class = "feature-item",
                  div(class = "bullet-point"),
                  div(class = "feature-text", "Intuitive dashboards and personalized insights")
              ),
              div(class = "feature-item",
                  div(class = "bullet-point"),
                  div(class = "feature-text", "Seamless integration with .csv health records")
              ),
              div(class = "feature-item",
                  div(class = "bullet-point"),
                  div(class = "feature-text", "Advanced trend tracking and customizable reports")
              ),
              div(class = "feature-item",
                  div(class = "bullet-point"),
                  div(class = "feature-text", "Empowers users to stay informed and take control of their health")
              )
          ),
          div(class = "start-button-container",
              actionButton("start_btn", "🚀 Start Analysis", class = "start-btn")
          )
      )
    )
  }
  
  customPageUI <- function() {
    tagList(
      div(class = "page-title-container",
          div(class = "page-title", "Health Data Analysis")
      ),
      div(class = "content-card",
          div(class = "file-input-container",
              div(class = "file-input-large",
                  fileInput("custom_file", "Upload CSV File:", accept = ".csv")
              )
          ),
          conditionalPanel(
            condition = "output.file_uploaded",
            div(class = "date-input-container",
                div(class = "date-input-large",
                    dateInput("custom_date", "Start Date:", format = "mm-dd-yyyy")
                ),
                div(class = "date-input-large",
                    dateInput("custom_end_date", "End Date:", format = "mm-dd-yyyy")
                )
            ),
            br(),
            actionButton("show_all_data", "📊 Show All Data", class = "btn-info")
          ),
          div(class = "text-data",
              verbatimTextOutput("custom_data")
          ),
          uiOutput("custom_charts"),
          div(class = "generate-summary-container",
              actionButton("generate_summary_custom", "✨ Generate Summary", class = "generate-summary-btn")
          ),
          br(),
          actionButton("back_custom", "← Back", class = "btn-secondary")
      )
    )
  }
  
  allDataPageUI <- function() {
    tagList(
      div(class = "page-title-container",
          div(class = "page-title", "Complete Dataset Overview")
      ),
      div(class = "content-card",
          div(class = "text-data",
              verbatimTextOutput("all_data")
          ),
          uiOutput("all_data_charts"),
          div(class = "generate-summary-container",
              actionButton("generate_summary_all", "✨ Generate Summary", class = "generate-summary-btn")
          ),
          br(),
          actionButton("back_all_data", "← Back to Analysis", class = "btn-secondary")
      )
    )
  }
  
  # Navigation
  observeEvent(input$start_btn, { page("custom") })
  observeEvent(input$back_custom, { page("main") })
  
  # Navigation to and from all data page
  observeEvent(input$show_all_data, { 
    previous_page("custom")
    page("alldata") 
  })
  observeEvent(input$back_all_data, { 
    page(previous_page()) 
  })
  
  # Generate Summary button handlers (placeholder functionality)
  observeEvent(input$generate_summary_custom, {
    showNotification("✨ Summary generation feature coming soon!", type = "message", duration = 3)
  })
  
  observeEvent(input$generate_summary_all, {
    showNotification("✨ Summary generation feature coming soon!", type = "message", duration = 3)
  })
  
  # File upload handlers
  output$file_uploaded <- reactive({
    return(!is.null(input$custom_file))
  })
  outputOptions(output, "file_uploaded", suspendWhenHidden = FALSE)
  
  observeEvent(input$custom_file, {
    req(input$custom_file)
    if(process_csv(input$custom_file$datapath)) {
      showNotification("CSV uploaded successfully!", type = "message")
    }
  })
  
  # Show all data on separate page
  output$all_data <- renderPrint({
    req(full_data)
    cat("=== COMPLETE DATASET ===\n")
    cat("Total rows:", nrow(original_data), "\n")
    cat("Column names:", paste(names(original_data), collapse = ", "), "\n")
    cat("Date column used:", date_col, "\n")
    if(!is.null(date_col)) {
      cat("Raw date values:", paste(head(original_data[[date_col]], 10), collapse = ", "), "\n")
    }
    cat("Successfully parsed dates:", sum(!is.na(full_data$Date)), "out of", nrow(full_data), "\n")
    if(sum(!is.na(full_data$Date)) > 0) {
      min_date <- min(full_data$Date, na.rm = TRUE)
      max_date <- max(full_data$Date, na.rm = TRUE)
      cat("Date range:", as.character(min_date), "to", as.character(max_date), "\n")
    }
    cat("========================\n\n")
    
    # Generate interactive charts for ALL data (complete dataset)
    output$all_data_charts <- renderUI({
      HTML(generate_interactive_charts(full_data, "alldata"))
    })
    
    # Show ALL records
    cat("DISPLAYING ALL", nrow(original_data), "RECORDS:\n")
    cat("========================================\n\n")
    
    for(i in 1:nrow(original_data)) {
      row <- original_data[i, ]
      cat("=== Record", i, "===\n")
      if(!is.null(date_col)) {
        cat("Date:", row[[date_col]], "\n")
      }
      
      # Show key columns only
      key_cols <- c("hr_min", "hr_max", "hr_avg", "sleep_total", "act_desc", "obs_desc")
      for(col in key_cols) {
        if(col %in% names(row) && !is.na(row[[col]]) && row[[col]] != "") {
          cat(col, ":", row[[col]], "\n")
        }
      }
      cat("\n")
    }
    
    cat("========================================\n")
    cat("END OF DATASET -", nrow(original_data), "total records displayed\n")
  })
  
  # Filter data and output for Custom date range
  output$custom_data <- renderPrint({
    req(input$custom_file, input$custom_date, input$custom_end_date, full_data)
    start_date <- as.Date(input$custom_date)
    end_date <- as.Date(input$custom_end_date)
    
    # Filter data
    df <- full_data[!is.na(full_data$Date) & 
                      full_data$Date >= start_date & 
                      full_data$Date <= end_date, ]
    
    cat("=== CUSTOM DATE RANGE RESULTS ===\n")
    cat("Selected range:", format(start_date, "%m-%d-%Y"), "to", format(end_date, "%m-%d-%Y"), "\n")
    cat("Total records in dataset:", nrow(full_data), "\n")
    cat("Records with valid dates:", sum(!is.na(full_data$Date)), "\n")
    valid_dates_count <- sum(!is.na(full_data$Date))
    if(valid_dates_count > 0) {
      min_date <- min(full_data$Date, na.rm = TRUE)
      max_date <- max(full_data$Date, na.rm = TRUE)
      cat("Available date range:", as.character(min_date), "to", as.character(max_date), "\n")
    }
    cat("Records found in selected range:", nrow(df), "\n")
    cat("================================\n\n")
    
    if (nrow(df) == 0) {
      cat("No data found in the selected date range.\n")
      if(valid_dates_count > 0) {
        min_date <- min(full_data$Date, na.rm = TRUE)
        max_date <- max(full_data$Date, na.rm = TRUE)
        cat("Try selecting dates between", as.character(min_date), "and", as.character(max_date), "\n")
      }
      
      # Clear charts
      output$custom_charts <- renderUI({ NULL })
    } else {
      # Show summary statistics
      if(!all(is.na(df$hr_avg))) {
        cat("Heart Rate - Avg:", round(mean(df$hr_avg, na.rm = TRUE), 1), 
            "| Range:", round(min(df$hr_min, na.rm = TRUE), 1), "-", round(max(df$hr_max, na.rm = TRUE), 1), "BPM\n")
      }
      
      if(!all(is.na(df$sleep_total))) {
        cat("Sleep - Avg Total:", round(mean(df$sleep_total, na.rm = TRUE), 1), "hrs",
            "| Avg Deep:", round(mean(df$sleep_deep, na.rm = TRUE), 1), "hrs\n")
      }
      
      if(!all(is.na(df$act_cat))) {
        activities <- table(df$act_cat[!is.na(df$act_cat)])
        cat("Activities:", paste(names(activities), "(", activities, ")", collapse = ", "), "\n")
      }
      
      cat("====================\n\n")
      
      # Generate interactive charts
      output$custom_charts <- renderUI({
        HTML(generate_interactive_charts(df, "custom"))
      })
      
      cat("Interactive charts generated above for your selected date range.\n")
      cat("Scroll up to explore detailed visualizations of your health data.\n")
    }
  })
}

shinyApp(ui, server)
