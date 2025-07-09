library(shiny)
library(reticulate)

# Initialize empty data
full_data <- NULL
original_data <- NULL
date_col <- NULL
summary_text <- ""

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .main-title-container {
        background-color: #3498db;
        padding: 30px 0;
        margin: -15px -15px 40px -15px;
        text-align: center;
      }
      .main-title {
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
    "))
  ),
  uiOutput("main_ui")
)

server <- function(input, output, session) {
  page <- reactiveVal("main")
  
  # Function to process uploaded CSV
  process_csv <- function(file_path) {
    tryCatch({
      original_data <<- read.csv(file_path, stringsAsFactors = FALSE)
      full_data <<- original_data
      
      # Find date column
      date_col <<- NULL
      for(col in names(full_data)) {
        if(grepl("date", col, ignore.case = TRUE)) {
          date_col <<- col
          break
        }
      }
      if(is.null(date_col)) {
        date_col <<- names(full_data)[1]
      }
      
      # Parse dates
      full_data$Date <<- tryCatch({
        parsed <- as.Date(full_data[[date_col]], format = "%m/%d/%Y")
        if(all(is.na(parsed))) parsed <- as.Date(full_data[[date_col]], format = "%m/%d/%y")
        if(all(is.na(parsed))) parsed <- as.Date(full_data[[date_col]], format = "%Y-%m-%d")
        if(all(is.na(parsed))) parsed <- as.Date(full_data[[date_col]])
        parsed
      }, error = function(e) rep(NA, nrow(full_data)))
      
      return(TRUE)
    }, error = function(e) {
      showNotification(paste("Error reading CSV:", e$message), type = "error")
      return(FALSE)
    })
  }
  
  # Reactive values for filtered data and summary
  filtered_data <- reactiveVal(NULL)
  summary_text <- reactiveVal("")
  
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
  
  # The four page UI functions, now each with a "Generate Summary" button and output text for summary
  todayPageUI <- function() {
    tagList(
      h4("Data for Today:"),
      fileInput("today_file", "Upload CSV File:", accept = ".csv"),
      verbatimTextOutput("today_data"),
      br(),
      actionButton("summary_today", "Generate Summary", class = "btn-primary"),
      verbatimTextOutput("summary_text_today"),
      br(),
      downloadButton("download_summary", "Download PDF"),
      br(),
      actionButton("back_today", "Back", class = "btn-secondary")
    )
  }
  
  past7PageUI <- function() {
    tagList(
      h4("Data for Past 7 Days:"),
      fileInput("past7_file", "Upload CSV File:", accept = ".csv"),
      verbatimTextOutput("past7_data"),
      br(),
      actionButton("summary_past7", "Generate Summary", class = "btn-primary"),
      verbatimTextOutput("summary_text_past7"),
      br(),
      downloadButton("download_summary", "Download PDF"),
      br(),
      actionButton("back_past7", "Back", class = "btn-secondary")
    )
  }
  
  past30PageUI <- function() {
    tagList(
      h4("Data for Past 30 Days:"),
      fileInput("past30_file", "Upload CSV File:", accept = ".csv"),
      verbatimTextOutput("past30_data"),
      br(),
      actionButton("summary_past30", "Generate Summary", class = "btn-primary"),
      verbatimTextOutput("summary_text_past30"),
      br(),
      downloadButton("download_summary", "Download PDF"),
      br(),
      actionButton("back_past30", "Back", class = "btn-secondary")
    )
  }
  
  customPageUI <- function() {
    tagList(
      h4("Custom Date Range:"),
      fileInput("custom_file", "Upload CSV File:", accept = ".csv"),
      conditionalPanel(
        condition = "output.file_uploaded",
        dateInput("custom_date", "Start Date:", format = "mm-dd-yyyy"),
        dateInput("custom_end_date", "End Date:", format = "mm-dd-yyyy"),
        br(),
        actionButton("show_all_data", "Show All Data (First 100 rows)", class = "btn-info")
      ),
      br(), br(),
      verbatimTextOutput("custom_data"),
      br(),
      actionButton("summary_custom", "Generate Summary", class = "btn-primary"),
      verbatimTextOutput("summary_text_custom"),
      br(),
      downloadButton("download_summary", "Download PDF"),
      br(),
      actionButton("back_custom", "Back", class = "btn-secondary")
    )
  }
  
  # Navigation buttons
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
    !is.null(input$custom_file)
  })
  outputOptions(output, "file_uploaded", suspendWhenHidden = FALSE)
  
  observeEvent(input$today_file, {
    req(input$today_file)
    if(process_csv(input$today_file$datapath)) {
      showNotification("CSV uploaded successfully!", type = "message")
      filtered_data(full_data)
      summary_text("")
    }
  })
  observeEvent(input$past7_file, {
    req(input$past7_file)
    if(process_csv(input$past7_file$datapath)) {
      showNotification("CSV uploaded successfully!", type = "message")
      filtered_data(full_data)
      summary_text("")
    }
  })
  observeEvent(input$past30_file, {
    req(input$past30_file)
    if(process_csv(input$past30_file$datapath)) {
      showNotification("CSV uploaded successfully!", type = "message")
      filtered_data(full_data)
      summary_text("")
    }
  })
  observeEvent(input$custom_file, {
    req(input$custom_file)
    if(process_csv(input$custom_file$datapath)) {
      showNotification("CSV uploaded successfully!", type = "message")
      filtered_data(full_data)
      summary_text("")
    }
  })
  
  # Show all data for custom page
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
        cat("Date range:", min(full_data$Date, na.rm = TRUE), "to", max(full_data$Date, na.rm = TRUE), "\n")
      }
      cat("========================\n\n")
      
      print(head(original_data, 50))
    })
  })
  
  # Filter & show data for each page
  output$today_data <- renderPrint({
    req(input$today_file, full_data)
    today <- Sys.Date()
    df <- full_data[!is.na(full_data$Date) & full_data$Date == today, ]
    filtered_data(df)
    if (nrow(df) == 0) {
      cat("No data available for", format(today, "%m-%d-%Y"), "\n")
      if(sum(!is.na(full_data$Date)) > 0) {
        cat("Available date range:", min(full_data$Date, na.rm = TRUE), "to", max(full_data$Date, na.rm = TRUE), "\n")
      }
    } else {
      cat("Found", nrow(df), "records for today:\n")
      print(df)
    }
  })
  
  output$past7_data <- renderPrint({
    req(input$past7_file, full_data)
    end_date <- Sys.Date()
    start_date <- end_date - 6
    df <- full_data[!is.na(full_data$Date) & full_data$Date >= start_date & full_data$Date <= end_date, ]
    filtered_data(df)
    if (nrow(df) == 0) {
      cat("No data available for past 7 days ending", format(end_date, "%m-%d-%Y"), "\n")
      if(sum(!is.na(full_data$Date)) > 0) {
        cat("Available date range:", min(full_data$Date, na.rm = TRUE), "to", max(full_data$Date, na.rm = TRUE), "\n")
      }
    } else {
      cat("Found", nrow(df), "records for past 7 days:\n")
      print(df)
    }
  })
  
  output$past30_data <- renderPrint({
    req(input$past30_file, full_data)
    end_date <- Sys.Date()
    start_date <- end_date - 29
    df <- full_data[!is.na(full_data$Date) & full_data$Date >= start_date & full_data$Date <= end_date, ]
    filtered_data(df)
    if (nrow(df) == 0) {
      cat("No data available for past 30 days ending", format(end_date, "%m-%d-%Y"), "\n")
      if(sum(!is.na(full_data$Date)) > 0) {
        cat("Available date range:", min(full_data$Date, na.rm = TRUE), "to", max(full_data$Date, na.rm = TRUE), "\n")
      }
    } else {
      cat("Found", nrow(df), "records for past 30 days:\n")
      print(df)
    }
  })
  
  output$custom_data <- renderPrint({
    req(input$custom_file, input$custom_date, input$custom_end_date, full_data)
    start_date <- as.Date(input$custom_date)
    end_date <- as.Date(input$custom_end_date)
    df <- full_data[!is.na(full_data$Date) & full_data$Date >= start_date & full_data$Date <= end_date, ]
    filtered_data(df)
    
    cat("=== CUSTOM DATE RANGE RESULTS ===\n")
    cat("Selected range:", format(start_date, "%m-%d-%Y"), "to", format(end_date, "%m-%d-%Y"), "\n")
    cat("Total records in dataset:", nrow(full_data), "\n")
    cat("Records with valid dates:", sum(!is.na(full_data$Date)), "\n")
    if(sum(!is.na(full_data$Date)) > 0) {
      cat("Available date range:", min(full_data$Date, na.rm = TRUE), "to", max(full_data$Date, na.rm = TRUE), "\n")
    }
    cat("Records found in selected range:", nrow(df), "\n")
    cat("================================\n\n")
    
    if (nrow(df) == 0) {
      cat("No data found in the selected date range.\n")
      if(sum(!is.na(full_data$Date)) > 0) {
        cat("Try selecting dates between", min(full_data$Date, na.rm = TRUE), "and", max(full_data$Date, na.rm = TRUE), "\n")
      }
    } else {
      cat("Showing", min(50, nrow(df)), "records:\n")
      cat("=======================\n")
      for(i in 1:min(50, nrow(df))) {
        row <- df[i, ]
        cat("Record", i, "- Date:", format(row$Date, "%m-%d-%Y"))
        for(col in names(row)) {
          if(col != "Date" && col != date_col && !is.na(row[[col]]) && row[[col]] != "") {
            cat(" |", col, ":", row[[col]])
          }
        }
        cat("\n")
      }
      if(nrow(df) > 50) {
        cat("... and", nrow(df) - 50, "more records\n")
      }
    }
  })
  
  # Generate summaries by calling the Python function
  observeEvent(input$summary_today, {
    df <- filtered_data()
    if (!is.null(df) && nrow(df) > 0) {
      summary <- tryCatch({
        template$generate_template_summary(df)
      }, error = function(e) {
        paste("Error generating summary:", e$message)
      })
      summary_text(summary)
    } else {
      summary_text("No data available to summarize.")
    }
  })
  
  output$summary_text_today <- renderText({
    summary_text()
  })
  
  observeEvent(input$summary_past7, {
    df <- filtered_data()
    if (!is.null(df) && nrow(df) > 0) {
      summary <- tryCatch({
        template$generate_template_summary(df)
      }, error = function(e) {
        paste("Error generating summary:", e$message)
      })
      summary_text(summary)
    } else {
      summary_text("No data available to summarize.")
    }
  })
  
  output$summary_text_past7 <- renderText({
    summary_text()
  })
  
  observeEvent(input$summary_past30, {
    df <- filtered_data()
    if (!is.null(df) && nrow(df) > 0) {
      summary <- tryCatch({
        template$generate_template_summary(df)
      }, error = function(e) {
        paste("Error generating summary:", e$message)
      })
      summary_text(summary)
    } else {
      summary_text("No data available to summarize.")
    }
  })
  
  output$summary_text_past30 <- renderText({
    summary_text()
  })
  
  observeEvent(input$summary_custom, {
    df <- filtered_data()
    if (!is.null(df) && nrow(df) > 0) {
      summary <- tryCatch({
        template$generate_template_summary(df)
      }, error = function(e) {
        paste("Error generating summary:", e$message)
      })
      summary_text(summary)
    } else {
      summary_text("No data available to summarize.")
    }
  })
  
  output$summary_text_custom <- renderText({
    summary_text()
    
    # PDF Export
    content = function(file) {
      tempReport <- tempfile(fileext = ".Rmd")
      writeLines(c(
        "---",
        "title: \"Caregiver Summary\"",
        "output: pdf_document",
        "---",
        "", 
        "```{r echo=FALSE, results='asis'}",
        "cat(summary_text())",
        "```"
      ), tempReport)
      rmarkdown::render(
        tempReport,
        output_file = file,
        envir      = new.env(parent = globalenv())
      )
    }
  })
}

shinyApp(ui, server)
