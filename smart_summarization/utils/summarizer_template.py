import pandas as pd

def generate_template_summary(df: pd.DataFrame) -> str:
    """
    Generate a rule-based summary from patient data with new structure.
    """
    data = df.copy()
    data["date"] = pd.to_datetime(data["date"], errors="coerce")
    data = data.dropna(subset=["date"])

    if data.empty:
        return "No data available to generate a summary."

    total_entries = len(data)
    start_date = data["date"].min().strftime("%b %d, %Y")
    end_date = data["date"].max().strftime("%b %d, %Y")

    # --- Heart Rate Summary ---
    if "hr_avg" in data.columns and not data["hr_avg"].dropna().empty:
        avg_hr = data["hr_avg"].mean()
        hr_display = f"{avg_hr:.1f} bpm"
    else:
        hr_display = "Not available"

    # --- Breathing Rate Summary ---
    if "br_avg" in data.columns and not data["br_avg"].dropna().empty:
        avg_br = data["br_avg"].mean()
        br_display = f"{avg_br:.1f} bpm"
    else:
        br_display = "Not available"

    # --- Oxygen Saturation Summary ---
    if "ox_avg" in data.columns and not data["ox_avg"].dropna().empty:
        avg_ox = data["ox_avg"].mean()
        ox_display = f"{avg_ox:.1f}%"
    else:
        ox_display = "Not available"

    # --- Sleep Summary ---
    if "sleep_total" in data.columns and not data["sleep_total"].dropna().empty:
        avg_sleep = data["sleep_total"].mean()
        sleep_display = f"{avg_sleep:.2f} hours"
    else:
        sleep_display = "Not available"

    # --- Activity Summary ---
    activity_summary = "No activity data available."
    if "act_desc" in data.columns and not data["act_desc"].dropna().empty:
        top_act = data["act_desc"].mode().iloc[0]
        act_count = data["act_desc"].value_counts().iloc[0]
        activity_summary = f"Most common activity was **{top_act}**, appearing {act_count} times."

    # --- Observation Summary ---
    obs_summary = "No observation data available."
    if "obs_desc" in data.columns and not data["obs_desc"].dropna().empty:
        top_obs = data["obs_desc"].mode().iloc[0]
        obs_count = data["obs_desc"].value_counts().iloc[0]
        obs_summary = f"Most common observation: **{top_obs}** ({obs_count} entries)."

    # --- Final Summary ---
    summary = (
        f"📅 **Date Range**: {start_date} to {end_date}\n"
        f"📊 **Total Records**: {total_entries}\n\n"
        f"❤️ **Vitals**:\n"
        f"- Avg. Heart Rate: **{hr_display}**\n"
        f"- Avg. Breathing Rate: **{br_display}**\n"
        f"- Avg. Oxygen Saturation: **{ox_display}**\n\n"
        f"🛌 **Sleep Summary**:\n"
        f"- Avg. Total Sleep: **{sleep_display}**\n\n"
        f"🏃 **Activity Overview**:\n"
        f"{activity_summary}\n\n"
        f"📝 **Observations**:\n"
        f"{obs_summary}\n\n"
        f"🔍 **Note**: This is a rule-based summary generated from structured data."
    )

    return summary

# --- Example Usage --- #
if __name__ == "__main__":
    file_path = "/Users/kyleshiroma/Downloads/dsa_task1_merge/clean_patient_x.csv"
    try:
        df = pd.read_csv(file_path)
        print(generate_template_summary(df))
    except Exception as e:
        print(f"Error: {e}")
