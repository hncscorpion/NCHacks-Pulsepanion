library(shiny)

# Initialize empty data
full_data <- NULL
original_data <- NULL
date_col <- NULL

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .main-title-container {
        background-color: #3498db;
        padding: 30px 0;
        margin: -15px -15px 40px -15px;
        text-align: center;
      }
      .page-title-container {
        background-color: #e74c3c;
        padding: 30px 0;
        margin: -15px -15px 40px -15px;
        text-align: center;
      }
      .main-title, .page-title {
        color: white;
        font-size: 3em;
        font-weight: bold;
        margin: 0;
      }
      .button-container {
        display: flex;
        justify-content: center;
        gap: 20px;
        flex-wrap: wrap;
        margin: 20px 0;
      }
      .main-btn {
        min-width: 150px;
        height: 60px;
        font-size: 18px;
        font-weight: bold;
        background-color: #e74c3c !important;
        border-color: #e74c3c !important;
        color: white !important;
      }
      .main-btn:hover {
        background-color: #c0392b !important;
        border-color: #c0392b !important;
        color: white !important;
      }
      .file-input-container {
        display: flex;
        justify-content: flex-start;
        margin: 30px 0;
      }
      .file-input-large {
        width: 100%;
        max-width: 500px;
      }
      .file-input-large .form-group {
        margin-bottom: 0;
      }
      .file-input-large label {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 10px;
        display: block;
      }
      .file-input-large input[type='file'] {
        font-size: 16px;
        padding: 15px;
        height: 60px;
        width: 100%;
        border: 2px solid #ddd;
        border-radius: 5px;
        background-color: #f9f9f9;
      }
      .date-input-container {
        display: flex;
        align-items: center;
        gap: 20px;
        margin: 30px 0;
        flex-wrap: wrap;
      }
      .date-input-large {
        flex: 1;
        min-width: 200px;
      }
      .date-input-large label {
        font-size: 16px;
        font-weight: bold;
        margin-bottom: 5px;
      }
      .date-input-large input {
        font-size: 16px;
        padding: 10px;
        height: 50px;
        width: 100%;
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
      div(class = "file-input-container",
          div(class = "file-input-large",
              fileInput("today_file", "Upload CSV File:", accept = ".csv")
          )
      ),
      verbatimTextOutput("today_data"),
      br(),
      actionButton("back_today", "Back", class = "btn-secondary")
    )
  }
  
  past7PageUI <- function() {
    tagList(
      div(class = "page-title-container",
          div(class = "page-title", "Patient Data: Past 7 Days")
      ),
      div(class = "file-input-container",
          div(class = "file-input-large",
              fileInput("past7_file", "Upload CSV File:", accept = ".csv")
          )
      ),
      verbatimTextOutput("past7_data"),
      br(),
      actionButton("back_past7", "Back", class = "btn-secondary")
    )
  }
  
  past30PageUI <- function() {
    tagList(
      div(class = "page-title-container",
          div(class = "page-title", "Patient Data: Past 30 Days")
      ),
      div(class = "file-input-container",
          div(class = "file-input-large",
              fileInput("past30_file", "Upload CSV File:", accept = ".csv")
          )
      ),
      verbatimTextOutput("past30_data"),
      br(),
      actionButton("back_past30", "Back", class = "btn-secondary")
    )
  }
  
  customPageUI <- function() {
    tagList(
      div(class = "page-title-container",
          div(class = "page-title", "Patient Data: Custom Range")
      ),
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
        actionButton("show_all_data", "Show All Data (First 100 rows)", class = "btn-info")
      ),
      br(), br(),
      verbatimTextOutput("custom_data"),
      br(),
      actionButton("back_custom", "Back", class = "btn-secondary")
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
      
      # Show first 50 rows of original data
      print(head(original_data, 50))
    })
  })
  
  # Filter data and output for Today
  output$today_data <- renderPrint({
    req(input$today_file, full_data)
    today <- Sys.Date()
    df <- full_data[!is.na(full_data$Date) & full_data$Date == today, ]
    if (nrow(df) == 0) {
      cat("No data available for", format(today, "%m-%d-%Y"), "\n")
      valid_dates_count <- sum(!is.na(full_data$Date))
      if(valid_dates_count > 0) {
        min_date <- min(full_data$Date, na.rm = TRUE)
        max_date <- max(full_data$Date, na.rm = TRUE)
        cat("Available date range:", as.character(min_date), "to", as.character(max_date), "\n")
      }
    } else {
      cat("Found", nrow(df), "records for today:\n")
      print(df)
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
      cat("No data available for past 7 days ending", format(end_date, "%m-%d-%Y"), "\n")
      valid_dates_count <- sum(!is.na(full_data$Date))
      if(valid_dates_count > 0) {
        min_date <- min(full_data$Date, na.rm = TRUE)
        max_date <- max(full_data$Date, na.rm = TRUE)
        cat("Available date range:", as.character(min_date), "to", as.character(max_date), "\n")
      }
    } else {
      cat("Found", nrow(df), "records for past 7 days:\n")
      print(df)
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
      cat("No data available for past 30 days ending", format(end_date, "%m-%d-%Y"), "\n")
      valid_dates_count <- sum(!is.na(full_data$Date))
      if(valid_dates_count > 0) {
        min_date <- min(full_data$Date, na.rm = TRUE)
        max_date <- max(full_data$Date, na.rm = TRUE)
        cat("Available date range:", as.character(min_date), "to", as.character(max_date), "\n")
      }
    } else {
      cat("Found", nrow(df), "records for past 30 days:\n")
      print(df)
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
    } else {
      cat("Showing", min(50, nrow(df)), "records:\n")
      cat("=======================\n")
      
      # Show data in a readable format
      for(i in 1:min(50, nrow(df))) {
        row <- df[i, ]
        cat("=== Record", i, "===\n")
        cat("Date:", format(row$Date, "%m-%d-%Y"), "\n")
        
        # Show key vital signs
        if(!is.na(row$hr_min) && !is.na(row$hr_max)) {
          cat("Heart Rate: Min", row$hr_min, "| Max", row$hr_max, "| Avg", round(row$hr_avg, 1), "\n")
        }
        
        # Show sleep data if available
        if(!is.na(row$sleep_total)) {
          cat("Sleep: Total", row$sleep_total, "hrs (Light:", row$sleep_light, "| Deep:", row$sleep_deep, "| REM:", row$sleep_rem, ")\n")
        }
        
        # Show activity description if not missing
        if(!is.na(row$act_desc) && row$act_desc != "") {
          cat("Activity:", row$act_desc, "\n")
          if(!is.na(row$act_cat)) cat("Category:", row$act_cat, "\n")
        }
        
        # Show observations if not missing
        if(!is.na(row$obs_desc) && row$obs_desc != "") {
          cat("Observation:", row$obs_desc, "\n")
          if(!is.na(row$obs_imp)) cat("Important:", row$obs_imp, "\n")
        }
        
        # Show breathing data if available
        if(!is.na(row$br_min) && !is.na(row$br_max)) {
          cat("Breathing Rate: Min", row$br_min, "| Max", row$br_max, "| Avg", row$br_avg, "\n")
        }
        
        cat("\n")
      }
      
      if(nrow(df) > 50) {
        cat("... and", nrow(df) - 50, "more records\n")
      }
    }
  })
}

shinyApp(ui, server)
