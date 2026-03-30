from openai import OpenAI
import re, os
from pathlib import Path
def process_string(funcid,history):
    client = OpenAI(
        api_key = "deepseekey", 
        base_url ="https://api.deepseek.com",
    )
    userprompt=f"""
    **Task**: Design a novel and effective mutation equality for differential evolution algorithm to generate offspring.
    
    **Requirement**:
    1. Output the update equality or rules using mathematics equality or pseudo code in latex format.
    2. Output a correct and complete MATLAB code file named 'updateFunc{funcid}.m', the function need to define as follows whose name is 'updateFunc' plus the current function ID int number:
       function [offspring] = updateFunc{funcid}(popdecs, popfits, cvs)
       The size of popdecs, popfit, cvs are N*D, N*M, and N*1, where N is population size, D is decision dimension and M is number of objective.
    3. The update function prefers vectorization operations and avoiding using toolbox functions.
    4. Check the generated MATLAB code carefully which must have no endless loop in the function.
    
    **History Feedback**:
    {history}
    
    **Output Farmat**:
    ```latex
    % update rule
    ```

    ```matlab
    % MATLAB Code
    ```
    """
    try:
        response = client.chat.completions.create(
            model="deepseek-chat",
            messages=[
                {"role": "system", "content": f"You are an operation and optimization expert and designing novel differential evolution algorithms."},
                {"role": "user", "content": userprompt},
            ],
            stream=False,
            temperature=0.3
        )
        
        if response is None:
            raise ValueError("Response from the API is None. Please check the API call or network connection.")
        
        response_content = response.choices[0].message.content
        print("Response content:", response_content)

    except Exception as e:
        response_content = ""
        
    code = extract_matlab_code(response_content)
    save_generation(float(funcid), response_content, userprompt)
    return code


def extract_matlab_code(text):
    match = re.search(r'```matlab\n(.*?)\n```', text, re.DOTALL)
    return match.group(1) if match else ""


def save_generation(functionnum, response, prompt):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    gen_dir = os.path.join(current_dir, 'generations')
    os.makedirs(gen_dir, exist_ok=True)
    
    response_path = os.path.join(gen_dir, f'func{functionnum}_response.txt')
    with open(response_path, 'w', encoding="utf-8", errors='ignore') as f:
        f.write(response)
    
    prompt_path = os.path.join(gen_dir, f'func{functionnum}_prompt.txt')
    with open(prompt_path, 'w', encoding="utf-8", errors='ignore') as f:
        f.write(prompt)
        

