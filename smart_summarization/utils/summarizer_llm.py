import os
import pandas as pd
import openai
from datetime import datetime

# Set your OpenAI API key here or make sure it's set in your environment variables
# Example: export OPENAI_API_KEY='your_api_key_here' in your shell
openai.api_key = os.getenv("OPENAI_API_KEY")

def generate_llm_summary(data):
    # Prepare prompt with patient data as a string
    prompt = "Summarize this patient data:\n" + data.to_string(index=False)
    
    try:
        response = openai.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": "You are a helpful assistant summarizing patient data."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.5,
            max_tokens=300
        )
        summary = response.choices[0].message.content.strip()
        return summary
    except Exception as e:
        return f"Error generating summary: {str(e)}"

if __name__ == "__main__":
    # Sample patient data
    data = {
        'Date': [datetime(2024, 5, 14), datetime(2024, 5, 15)],
        'SleepDuration': [7.5, 8.0],
        'HeartRate': [70, 68],
        'Notes': ["Normal sleep", "Mild coughing observed"]
    }

    df = pd.DataFrame(data)
    
    summary = generate_llm_summary(df)
    print(summary)
