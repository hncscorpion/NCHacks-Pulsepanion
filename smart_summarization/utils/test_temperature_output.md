# Test: Temperature Output

GPT Model = 4.0-mini

## Temperature = 0.5

Balanced between creative and deterministic response.

### Output

The patient data includes two entries:

- **May 14, 2024**: The patient had a sleep duration of 7.5 hours with a heart rate of 70 bpm. The note indicates normal sleep.
  
- **May 15, 2024**: The patient had a sleep duration of 8.0 hours with a heart rate of 68 bpm. Mild coughing was observed on this day. 

Overall, the patient experienced normal sleep patterns with a slight increase in sleep duration, but also reported mild coughing on the second day.

### Feedback

- Bullet points used = good
- Lines are a little long
- Info = accurate
- Good: added small summary at bottom
- Meh: the bottom summary just restates the info from above in sentence form; not terribly useful

## Temperature = 0.6

Is the output more informative if temperature is increased? If so, will test temp=0.7. Else, will test temp=0.4 to check if more deterministic is better.

### Output

The patient data for May 14 and May 15, 2024, is as follows:

- **May 14, 2024**: 
  - Sleep Duration: 7.5 hours 
  - Heart Rate: 70 bpm 
  - Notes: Normal sleep

- **May 15, 2024**: 
  - Sleep Duration: 8.0 hours 
  - Heart Rate: 68 bpm 
  - Notes: Mild coughing observed 

Overall, the patient had adequate sleep duration on both days, with a slight decrease in heart rate from May 14 to May 15, and mild coughing was noted on the second day.

### Feedback

- Good
    - bit easier to read (better use of several short bullet points than just two long ones)
    - bullet point nesting under relevant days
    - information given in easy to read format
    - summary at bottom
- Bad
    - summary is just restating again
    - this summary just called attention to a different trend than the first output (they're one or the other but not both for some reason? like it's ignoring the presence of other trends?)
- Action: Increase temperature.

## Temperature = 0.7

### Output

The patient data from May 14 to May 15, 2024, includes the following information:

- **May 14, 2024**: The patient had a sleep duration of 7.5 hours and a heart rate of 70 bpm, with notes indicating normal sleep.
- **May 15, 2024**: The patient had a sleep duration of 8.0 hours and a heart rate of 68 bpm, with mild coughing observed.

### Feedback

- Bad:
    - Worst output so far.
    - Less readable than lower temperatures tested
 
- Temperature=6 was better.
- Action: Trying Temperature=6.5 to see if 6.5 is better than 6 and 7.

## Temperature = 6.5

### Output

The patient data includes two entries:

1. **Date:** May 14, 2024
   - **Sleep Duration:** 7.5 hours
   - **Heart Rate:** 70 bpm
   - **Notes:** Normal sleep

2. **Date:** May 15, 2024
   - **Sleep Duration:** 8.0 hours
   - **Heart Rate:** 68 bpm
   - **Notes:** Mild coughing observed

Overall, the patient experienced normal sleep and a slight decrease in heart rate over the two days, with mild coughing noted on the second day.

### Feedback

- Bad
    - Slightly harder to read than 0.6 (the word "Date" is bolded twice but not the actual dates themselves
    - it's ignoring one of the trends (the sleep duration diff again)
- Action: (Tentative) Keep Temperature = 0.6 for testing of other parameters. Testing more lower temperature values just to double check.

## Temperature = 0.4

### Output

The patient data includes two entries:

1. **Date:** May 14, 2024
   - **Sleep Duration:** 7.5 hours
   - **Heart Rate:** 70 bpm
   - **Notes:** Normal sleep

2. **Date:** May 15, 2024
   - **Sleep Duration:** 8.0 hours
   - **Heart Rate:** 68 bpm
   - **Notes:** Mild coughing observed

Overall, the patient experienced normal sleep patterns with a slight increase in sleep duration on the second day, but mild coughing was noted. Heart rates were within a normal range.

### Feedback

- Not better than 0.5. Keeping Temperature = 0.6.
- 