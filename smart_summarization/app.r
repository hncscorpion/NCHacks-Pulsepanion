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
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        margin: 0;
        padding: 0;
        min-height: 100vh;
      }
      
      .container-fluid {
        background: transparent;
        padding: 0;
      }
      
      .main-title-container {
        background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
        padding: 40px 0;
        margin: 0 0 40px 0;
        text-align: center;
        box-shadow: 0 10px 30px rgba(52, 152, 219, 0.3);
        position: relative;
        overflow: hidden;
      }
      
      .main-title-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
        animation: shimmer 3s infinite;
      }
      
      @keyframes shimmer {
        0% { left: -100%; }
        100% { left: 100%; }
      }
      
      .page-title-container {
        background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        padding: 40px 0;
        margin: 0 0 40px 0;
        text-align: center;
        box-shadow: 0 10px 30px rgba(231, 76, 60, 0.3);
        position: relative;
        overflow: hidden;
      }
      
      .page-title-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
        animation: shimmer 3s infinite;
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
      
      .button-container {
        display: flex;
        justify-content: center;
        gap: 25px;
        flex-wrap: wrap;
        margin: 40px 0;
        padding: 0 20px;
      }
      
      .main-btn {
        min-width: 180px;
        height: 70px;
        font-size: 18px;
        font-weight: 600;
        background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        border: none;
        border-radius: 15px;
        color: white;
        cursor: pointer;
        position: relative;
        overflow: hidden;
        box-shadow: 0 8px 25px rgba(231, 76, 60, 0.3);
        transform: translateY(0);
        letter-spacing: 0.5px;
      }
      
      .main-btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
        transition: left 0.5s;
      }
      
      .main-btn:hover {
        transform: translateY(-4px);
        box-shadow: 0 15px 35px rgba(231, 76, 60, 0.4);
        background: linear-gradient(135deg, #c0392b 0%, #e74c3c 100%);
      }
      
      .main-btn:hover::before {
        left: 100%;
      }
      
      .main-btn:active {
        transform: translateY(-2px);
        box-shadow: 0 10px 25px rgba(231, 76, 60, 0.3);
      }
      
      .content-card {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        border-radius: 20px;
        padding: 30px;
        margin: 20px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        animation: slideIn 0.6s cubic-bezier(0.4, 0, 0.2, 1);
      }
      
      @keyframes slideIn {
        from {
          opacity: 0;
          transform: translateY(30px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
      
      .charts-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
        gap: 25px;
        margin: 30px 0;
        animation: fadeIn 0.8s ease-out 0.4s both;
      }
      
      .chart-card {
        background: rgba(255, 255, 255, 0.9);
        border-radius: 15px;
        padding: 25px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
        border: 1px solid rgba(255, 255, 255, 0.3);
        transition: all 0.3s ease;
      }
      
      .chart-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
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
        animation: fadeIn 0.8s ease-out 0.2s both;
      }
      
      @keyframes fadeIn {
        from {
          opacity: 0;
          transform: translateX(-20px);
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
      }
      
      .file-input-large input[type='file'] {
        font-size: 16px;
        padding: 20px;
        height: 70px;
        width: 100%;
        border: 3px dashed #ddd;
        border-radius: 15px;
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        cursor: pointer;
        transition: all 0.3s ease;
        font-weight: 500;
      }
      
      .file-input-large input[type='file']:hover {
        border-color: #3498db;
        background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(52, 152, 219, 0.2);
      }
      
      .file-input-large input[type='file']:focus {
        outline: none;
        border-color: #2980b9;
        box-shadow: 0 0 0 4px rgba(52, 152, 219, 0.1);
      }
      
      .date-input-container {
        display: flex;
        align-items: center;
        gap: 25px;
        margin: 30px 0;
        flex-wrap: wrap;
        animation: fadeIn 0.8s ease-out 0.4s both;
      }
      
      .date-input-large {
        flex: 1;
        min-width: 200px;
      }
      
      .date-input-large label {
        font-size: 16px;
        font-weight: 600;
        margin-bottom: 8px;
        color: #2c3e50;
        letter-spacing: 0.3px;
      }
      
      .date-input-large input {
        font-size: 16px;
        padding: 15px;
        height: 55px;
        width: 100%;
        border: 2px solid #e1e8ed;
        border-radius: 12px;
        background: white;
        font-weight: 500;
        transition: all 0.3s ease;
      }
      
      .date-input-large input:hover {
        border-color: #3498db;
        box-shadow: 0 4px 15px rgba(52, 152, 219, 0.1);
      }
      
      .date-input-large input:focus {
        outline: none;
        border-color: #2980b9;
        box-shadow: 0 0 0 4px rgba(52, 152, 219, 0.1);
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
      
      .btn-info:hover {
        background: linear-gradient(135deg, #138496 0%, #17a2b8 100%);
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(23, 162, 184, 0.3);
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
        .main-title, .page-title {
          font-size: 2.5em;
        }
        
        .button-container {
          gap: 15px;
        }
        
        .main-btn {
          min-width: 150px;
          height: 60px;
          font-size: 16px;
        }
        
        .content-card {
          margin: 10px;
          padding: 20px;
        }
        
        .date-input-container {
          flex-direction: column;
          gap: 15px;
        }
        
        .charts-container {
          grid-template-columns: 1fr;
          gap: 20px;
        }
      }
    "))
  ),
  uiOutput("main_ui")
)

server <- function(input, output, session) {
  page <- reactiveVal("main")
  
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
    if(!all(is.na(df$hr_avg))) {
      charts_html <- paste0(charts_html,
                            '<div class="chart-card">',
                            '<div class="chart-title">💓 Heart Rate Trends</div>',
                            '<canvas id="', chart_id_hr, '" class="chart-canvas"></canvas>',
                            '</div>'
      )
    }
    
    # Sleep Chart
    if(!all(is.na(df$sleep_total))) {
      charts_html <- paste0(charts_html,
                            '<div class="chart-card">',
                            '<div class="chart-title">😴 Sleep Analysis</div>',
                            '<canvas id="', chart_id_sleep, '" class="chart-canvas"></canvas>',
                            '</div>'
      )
    }
    
    # Activity Chart
    if(!all(is.na(df$act_cat))) {
      charts_html <- paste0(charts_html,
                            '<div class="chart-card">',
                            '<div class="chart-title">📊 Activity Categories</div>',
                            '<canvas id="', chart_id_activity, '" class="chart-canvas"></canvas>',
                            '</div>'
      )
    }
    
    # Breathing Chart
    if(!all(is.na(df$br_avg))) {
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
    
    if(!all(is.na(df$hr_avg))) {
      charts_html <- paste0(charts_html, create_heart_rate_js(df, chart_id_hr))
    }
    
    if(!all(is.na(df$sleep_total))) {
      charts_html <- paste0(charts_html, create_sleep_js(df, chart_id_sleep))
    }
    
    if(!all(is.na(df$act_cat))) {
      charts_html <- paste0(charts_html, create_activity_js(df, chart_id_activity))
    }
    
    if(!all(is.na(df$br_avg))) {
      charts_html <- paste0(charts_html, create_breathing_js(df, chart_id_breathing))
    }
    
    charts_html <- paste0(charts_html, '</script>')
    
    return(charts_html)
  }
  
  # Heart Rate Interactive Chart JavaScript
  create_heart_rate_js <- function(df, chart_id) {
    valid_data <- df[!is.na(df$hr_avg), ]
    if(nrow(valid_data) == 0) return("")
    
    dates <- format(valid_data$Date, "%m-%d")
    hr_min <- valid_data$hr_min
    hr_max <- valid_data$hr_max
    hr_avg <- valid_data$hr_avg
    
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
                borderWidth: 2
              }, {
                label: "Average HR", 
                data: ', avg_js, ',
                borderColor: "#e74c3c",
                backgroundColor: "rgba(231, 76, 60, 0.1)",
                fill: false,
                tension: 0.4,
                borderWidth: 3
              }, {
                label: "Max HR",
                data: ', max_js, ',
                borderColor: "#f39c12",
                backgroundColor: "rgba(243, 156, 18, 0.1)",
                fill: false,
                tension: 0.4,
                borderWidth: 2
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
                  intersect: false
                }
              },
              scales: {
                x: {
                  display: true,
                  title: {
                    display: true,
                    text: "Date"
                  }
                },
                y: {
                  display: true,
                  title: {
                    display: true,
                    text: "BPM"
                  }
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
    valid_data <- df[!is.na(df$sleep_total), ]
    if(nrow(valid_data) == 0) return("")
    
    dates <- format(valid_data$Date, "%m-%d")
    sleep_light <- valid_data$sleep_light
    sleep_deep <- valid_data$sleep_deep
    sleep_rem <- valid_data$sleep_rem
    
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
                  intersect: false
                }
              },
              scales: {
                x: {
                  stacked: true,
                  title: {
                    display: true,
                    text: "Date"
                  }
                },
                y: {
                  stacked: true,
                  title: {
                    display: true,
                    text: "Hours"
                  }
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
    valid_data <- df[!is.na(df$br_avg), ]
    if(nrow(valid_data) == 0) return("")
    
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
                pointRadius: 6,
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
                  }
                },
                y: {
                  title: {
                    display: true,
                    text: "Breaths/min"
                  }
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
           "today" = todayPageUI(),
           "past7" = past7PageUI(),
           "past30" = past30PageUI(),
           "custom" = customPageUI()
    )
  })
  
  mainPageUI <- function() {
    tagList(
      div(class = "main-title-container",
          div(class = "main-title", "Patient Data Dashboard")
      ),
      div(class = "button-container",
          actionButton("today_btn", "Today", class = "main-btn"),
          actionButton("past7_btn", "Past 7 Days", class = "main-btn"),
          actionButton("past30_btn", "Past 30 Days", class = "main-btn"),
          actionButton("custom_btn", "Custom Range", class = "main-btn")
      )
    )
  }
  
  todayPageUI <- function() {
    tagList(
      div(class = "page-title-container",
          div(class = "page-title", "Patient Data: Today")
      ),
      div(class = "content-card",
          div(class = "file-input-container",
              div(class = "file-input-large",
                  fileInput("today_file", "Upload CSV File:", accept = ".csv")
              )
          ),
          div(class = "text-data",
              verbatimTextOutput("today_data")
          ),
          uiOutput("today_charts"),
          br(),
          actionButton("back_today", "← Back", class = "btn-secondary")
      )
    )
  }
  
  past7PageUI <- function() {
    tagList(
      div(class = "page-title-container",
          div(class = "page-title", "Patient Data: Past 7 Days")
      ),
      div(class = "content-card",
          div(class = "file-input-container",
              div(class = "file-input-large",
                  fileInput("past7_file", "Upload CSV File:", accept = ".csv")
              )
          ),
          div(class = "text-data",
              verbatimTextOutput("past7_data")
          ),
          uiOutput("past7_charts"),
          br(),
          actionButton("back_past7", "← Back", class = "btn-secondary")
      )
    )
  }
  
  past30PageUI <- function() {
    tagList(
      div(class = "page-title-container",
          div(class = "page-title", "Patient Data: Past 30 Days")
      ),
      div(class = "content-card",
          div(class = "file-input-container",
              div(class = "file-input-large",
                  fileInput("past30_file", "Upload CSV File:", accept = ".csv")
              )
          ),
          div(class = "text-data",
              verbatimTextOutput("past30_data")
          ),
          uiOutput("past30_charts"),
          br(),
          actionButton("back_past30", "← Back", class = "btn-secondary")
      )
    )
  }
  
  customPageUI <- function() {
    tagList(
      div(class = "page-title-container",
          div(class = "page-title", "Patient Data: Custom Range")
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
          br(),
          actionButton("back_custom", "← Back", class = "btn-secondary")
      )
    )
  }
  
  # Navigation
  observeEvent(input$today_btn, { page("today") })
  observeEvent(input$past7_btn, { page("past7") })
  observeEvent(input$past30_btn, { page("past30") })
  observeEvent(input$custom_btn, { page("custom") })
  
  observeEvent(input$back_today, { page("main") })
  observeEvent(input$back_past7, { page("main") })
  observeEvent(input$back_past30, { page("main") })
  observeEvent(input$back_custom, { page("main") })
  
  # File upload handlers
  output$file_uploaded <- reactive({
    return(!is.null(input$custom_file))
  })
  outputOptions(output, "file_uploaded", suspendWhenHidden = FALSE)
  
  observeEvent(input$today_file, {
    req(input$today_file)
    if(process_csv(input$today_file$datapath)) {
      showNotification("CSV uploaded successfully!", type = "message")
    }
  })
  
  observeEvent(input$past7_file, {
    req(input$past7_file)
    if(process_csv(input$past7_file$datapath)) {
      showNotification("CSV uploaded successfully!", type = "message")
    }
  })
  
  observeEvent(input$past30_file, {
    req(input$past30_file)
    if(process_csv(input$past30_file$datapath)) {
      showNotification("CSV uploaded successfully!", type = "message")
    }
  })
  
  observeEvent(input$custom_file, {
    req(input$custom_file)
    if(process_csv(input$custom_file$datapath)) {
      showNotification("CSV uploaded successfully!", type = "message")
    }
  })
  
  # Show all data button
  observeEvent(input$show_all_data, {
    req(full_data)
    output$custom_data <- renderPrint({
      cat("=== FULL DATA PREVIEW ===\n")
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
      
      # Generate interactive charts for all data
      output$custom_charts <- renderUI({
        HTML(generate_interactive_charts(head(full_data, 100), "preview"))
      })
      
      # Show sample records
      for(i in 1:min(10, nrow(original_data))) {
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
      
      if(nrow(original_data) > 10) {
        cat("... and", nrow(original_data) - 10, "more records\n")
      }
    })
  })
  
  # Filter data and output for Today
  output$today_data <- renderPrint({
    req(input$today_file, full_data)
    today <- Sys.Date()
    df <- full_data[!is.na(full_data$Date) & full_data$Date == today, ]
    
    if (nrow(df) == 0) {
      cat("=== TODAY'S DATA ===\n")
      cat("Date:", format(today, "%m-%d-%Y"), "\n")
      cat("No data available for today's date.\n\n")
      valid_dates_count <- sum(!is.na(full_data$Date))
      if(valid_dates_count > 0) {
        min_date <- min(full_data$Date, na.rm = TRUE)
        max_date <- max(full_data$Date, na.rm = TRUE)
        cat("Available date range:", as.character(min_date), "to", as.character(max_date), "\n")
      }
      
      # Clear charts
      output$today_charts <- renderUI({ NULL })
    } else {
      cat("=== TODAY'S DATA ===\n")
      cat("Total records found:", nrow(df), "\n")
      cat("================================\n\n")
      
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
      output$today_charts <- renderUI({
        HTML(generate_interactive_charts(df, "today"))
      })
      
      cat("Interactive charts generated above showing today's health data.\n")
      cat("Scroll up to explore detailed visualizations.\n")
    }
  })
  
  # Filter data and output for Past 7 Days
  output$past7_data <- renderPrint({
    req(input$past7_file, full_data)
    end_date <- Sys.Date()
    start_date <- end_date - 6
    df <- full_data[!is.na(full_data$Date) & 
                      full_data$Date >= start_date & 
                      full_data$Date <= end_date, ]
    
    if (nrow(df) == 0) {
      cat("=== PAST 7 DAYS DATA ===\n")
      cat("Date range:", format(start_date, "%m-%d-%Y"), "to", format(end_date, "%m-%d-%Y"), "\n")
      cat("No data available for this time period.\n\n")
      valid_dates_count <- sum(!is.na(full_data$Date))
      if(valid_dates_count > 0) {
        min_date <- min(full_data$Date, na.rm = TRUE)
        max_date <- max(full_data$Date, na.rm = TRUE)
        cat("Available date range:", as.character(min_date), "to", as.character(max_date), "\n")
      }
      
      # Clear charts
      output$past7_charts <- renderUI({ NULL })
    } else {
      cat("=== PAST 7 DAYS DATA ===\n")
      cat("Total records found:", nrow(df), "\n")
      cat("Date range:", format(start_date, "%m-%d-%Y"), "to", format(end_date, "%m-%d-%Y"), "\n")
      cat("================================\n\n")
      
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
      output$past7_charts <- renderUI({
        HTML(generate_interactive_charts(df, "past7"))
      })
      
      cat("Interactive charts generated above showing trends over the past 7 days.\n")
      cat("Scroll up to view detailed visualizations of your health data.\n")
    }
  })
  
  # Filter data and output for Past 30 Days
  output$past30_data <- renderPrint({
    req(input$past30_file, full_data)
    end_date <- Sys.Date()
    start_date <- end_date - 29
    df <- full_data[!is.na(full_data$Date) & 
                      full_data$Date >= start_date & 
                      full_data$Date <= end_date, ]
    
    if (nrow(df) == 0) {
      cat("=== PAST 30 DAYS DATA ===\n")
      cat("Date range:", format(start_date, "%m-%d-%Y"), "to", format(end_date, "%m-%d-%Y"), "\n")
      cat("No data available for this time period.\n\n")
      valid_dates_count <- sum(!is.na(full_data$Date))
      if(valid_dates_count > 0) {
        min_date <- min(full_data$Date, na.rm = TRUE)
        max_date <- max(full_data$Date, na.rm = TRUE)
        cat("Available date range:", as.character(min_date), "to", as.character(max_date), "\n")
      }
      
      # Clear charts
      output$past30_charts <- renderUI({ NULL })
    } else {
      cat("=== PAST 30 DAYS DATA ===\n")
      cat("Total records found:", nrow(df), "\n")
      cat("Date range:", format(start_date, "%m-%d-%Y"), "to", format(end_date, "%m-%d-%Y"), "\n")
      cat("================================\n\n")
      
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
      output$past30_charts <- renderUI({
        HTML(generate_interactive_charts(df, "past30"))
      })
      
      cat("Interactive charts generated above showing trends over the past 30 days.\n")
      cat("Scroll up to view comprehensive visualizations of your health data patterns.\n")
    }
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
