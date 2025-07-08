# Smart Summarization for Caregivers

Smart Summarization is a lightweight, AI-assisted tool designed to help caregivers quickly understand trends in patient health data over time. Users can generate natural-language summaries of patient vitals, observations, and activities over a selected time range, then export reports as PDF files.

## Features

- Selectable date ranges (e.g., today, last 7 days, custom range)
- AI-based summarization using GPT or rule-based logic
- Downloadable reports in PDF format
- Simple, caregiver-friendly UI built with Streamlit

## Tech Stack

- Python (pandas, OpenAI API)
- Streamlit (for UI)
- PDF generation: pdfkit or WeasyPrint
- Version control: Git + GitHub

## Folder Structure

smart_summarization/
├── app.py # Main Streamlit app entry point
├── .env # API keys and environment variables (not committed)
├── requirements.txt # Python dependencies
│
├── data/ # Raw and merged CSV files
│ ├── patient_x_jan_jun_2024.csv
│ ├── patient_x_jul_dec_2024.csv
│ ├── patient_x_jan_jun_2025.csv
│ └── merged_patient_data.csv
│
├── outputs/ # Exported reports (PDFs, text)
│ └── sample_report.pdf
│
├── utils/ # Helper modules for data and summarization
│ ├── summarizer_llm.py # GPT-based summarization
│ ├── summarizer_template.py # Rule-based summarization
│ ├── data_utils.py # Data loading, merging, filtering
│ └── export_pdf.py # PDF generation logic
│
└── README.md # Project overview and documentation

## Team

| Role             | Name              | GitHub                          |
|------------------|-------------------|----------------------------------|
| Supervisor       | Prof. Hutchings   | —                                |
| Team Captain     | Kyle Shiroma      | [k-shiroma-code](https://github.com/k-shiroma-code) |
| Data Scientist A | Mikhaela Lewis    | [mjlewis-seq](https://github.com/mjlewis-seq) |
| Data Scientist B | TBD               | —                                |
| Programmer A     | TBD               | —                                |
| Programmer B     | Ryan Manuel       | [hncscorpion](https://github.com/hncscorpion) |

## Project Goal

Build a working prototype by July 13, 2025, including:
- A functioning UI with summarization
- Downloadable PDF reports
- Presentation-ready slide deck (5–6 slides)

## Status

In progress. Dataset merging and UI skeleton underway.
