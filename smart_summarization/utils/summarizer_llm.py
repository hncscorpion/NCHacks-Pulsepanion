{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "49726f41-9541-4ab8-98b7-ad2092d49baf",
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Collecting openai\n",
      "  Downloading openai-1.93.2-py3-none-any.whl.metadata (29 kB)\n",
      "Requirement already satisfied: anyio<5,>=3.5.0 in /opt/anaconda3/lib/python3.11/site-packages (from openai) (4.2.0)\n",
      "Requirement already satisfied: distro<2,>=1.7.0 in /opt/anaconda3/lib/python3.11/site-packages (from openai) (1.8.0)\n",
      "Requirement already satisfied: httpx<1,>=0.23.0 in /opt/anaconda3/lib/python3.11/site-packages (from openai) (0.28.1)\n",
      "Collecting jiter<1,>=0.4.0 (from openai)\n",
      "  Downloading jiter-0.10.0-cp311-cp311-macosx_11_0_arm64.whl.metadata (5.2 kB)\n",
      "Requirement already satisfied: pydantic<3,>=1.9.0 in /opt/anaconda3/lib/python3.11/site-packages (from openai) (2.11.7)\n",
      "Requirement already satisfied: sniffio in /opt/anaconda3/lib/python3.11/site-packages (from openai) (1.3.0)\n",
      "Requirement already satisfied: tqdm>4 in /opt/anaconda3/lib/python3.11/site-packages (from openai) (4.65.0)\n",
      "Requirement already satisfied: typing-extensions<5,>=4.11 in /opt/anaconda3/lib/python3.11/site-packages (from openai) (4.13.2)\n",
      "Requirement already satisfied: idna>=2.8 in /opt/anaconda3/lib/python3.11/site-packages (from anyio<5,>=3.5.0->openai) (3.4)\n",
      "Requirement already satisfied: certifi in /opt/anaconda3/lib/python3.11/site-packages (from httpx<1,>=0.23.0->openai) (2025.6.15)\n",
      "Requirement already satisfied: httpcore==1.* in /opt/anaconda3/lib/python3.11/site-packages (from httpx<1,>=0.23.0->openai) (1.0.2)\n",
      "Requirement already satisfied: h11<0.15,>=0.13 in /opt/anaconda3/lib/python3.11/site-packages (from httpcore==1.*->httpx<1,>=0.23.0->openai) (0.14.0)\n",
      "Requirement already satisfied: annotated-types>=0.6.0 in /opt/anaconda3/lib/python3.11/site-packages (from pydantic<3,>=1.9.0->openai) (0.6.0)\n",
      "Requirement already satisfied: pydantic-core==2.33.2 in /opt/anaconda3/lib/python3.11/site-packages (from pydantic<3,>=1.9.0->openai) (2.33.2)\n",
      "Requirement already satisfied: typing-inspection>=0.4.0 in /opt/anaconda3/lib/python3.11/site-packages (from pydantic<3,>=1.9.0->openai) (0.4.1)\n",
      "Downloading openai-1.93.2-py3-none-any.whl (755 kB)\n",
      "\u001b[2K   \u001b[90m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\u001b[0m \u001b[32m755.1/755.1 kB\u001b[0m \u001b[31m5.7 MB/s\u001b[0m eta \u001b[36m0:00:00\u001b[0ma \u001b[36m0:00:01\u001b[0m\n",
      "\u001b[?25hDownloading jiter-0.10.0-cp311-cp311-macosx_11_0_arm64.whl (321 kB)\n",
      "\u001b[2K   \u001b[90m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\u001b[0m \u001b[32m322.0/322.0 kB\u001b[0m \u001b[31m5.8 MB/s\u001b[0m eta \u001b[36m0:00:00\u001b[0ma \u001b[36m0:00:01\u001b[0m\n",
      "\u001b[?25hInstalling collected packages: jiter, openai\n",
      "Successfully installed jiter-0.10.0 openai-1.93.2\n"
     ]
    }
   ],
   "source": [
    "!pip install openai"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 21,
   "id": "4637b6f1-86da-4588-b5f4-8209a22ada67",
   "metadata": {},
   "outputs": [],
   "source": [
    "import openai\n",
    "import os\n",
    "\n",
    "openai.api_key = os.getenv(\"OPENAI_API_KEY\")\n",
    "\n",
    "def generate_llm_summary(data):\n",
    "    # Prepare your prompt based on the data (string)\n",
    "    prompt = \"Summarize this patient data:\\n\" + data.to_string(index=False)\n",
    "    \n",
    "    try:\n",
    "        response = openai.chat.completions.create(\n",
    "            model=\"gpt-4o-mini\",\n",
    "            messages=[\n",
    "                {\"role\": \"system\", \"content\": \"You are a helpful assistant summarizing patient data.\"},\n",
    "                {\"role\": \"user\", \"content\": prompt}\n",
    "            ],\n",
    "            temperature=0.5,\n",
    "            max_tokens=300\n",
    "        )\n",
    "        \n",
    "        # Extract text from response\n",
    "        summary = response.choices[0].message.content.strip()\n",
    "        return summary\n",
    "    except Exception as e:\n",
    "        return f\"Error generating summary: {str(e)}\"\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 23,
   "id": "9dd0f8dc-14a7-4d24-8cdc-c8614225c12c",
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Error generating summary: The api_key client option must be set either by passing api_key to the client or by setting the OPENAI_API_KEY environment variable\n"
     ]
    }
   ],
   "source": [
    "import pandas as pd\n",
    "from datetime import datetime\n",
    "\n",
    "# Sample patient data\n",
    "data = {\n",
    "    'Date': [datetime(2024, 5, 14), datetime(2024, 5, 15)],\n",
    "    'SleepDuration': [7.5, 8.0],\n",
    "    'HeartRate': [70, 68],\n",
    "    'Notes': [\"Normal sleep\", \"Mild coughing observed\"]\n",
    "}\n",
    "\n",
    "df = pd.DataFrame(data)\n",
    "\n",
    "summary = generate_llm_summary(df)\n",
    "print(summary)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "3e913574-c7da-4b92-97d6-65e29bdbecee",
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3 (ipykernel)",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.11.7"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
