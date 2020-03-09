import numpy as np
import pandas as pd
np.random.seed(12312) #So the sequences generated are consistent - change the number here to make new sequences

def genTrials(n,h,p):
    '''
    Function to generate trials for tone task
    n: number of trials (scalar)
    h: hazard rate (between 0 and 1)
    p: bernoulli probability that the tone will be the same as the tone
    '''
    s_t = np.zeros((n,2))
    p_h_probs = np.random.uniform(size=(n,2))
    sources = np.array([1,2])
    currSource = np.random.choice(sources)
    for i in np.arange(n):
        #Apply hazard rate
        if p_h_probs[i,1] < h:
            currSource = sources[sources != currSource]
        
        #Save source
        s_t[i,0] = currSource
        
        #Generate tone
        if p_h_probs[i,0] < p:
            s_t[i,1] = currSource
        else:
            s_t[i,1] = sources[sources!=currSource]
    return(pd.DataFrame(s_t,columns=['Source','Tone']))

# Generate/save low hazard tones
low_h_tones = genTrials(200,.1,.9)
low_h_tones.to_csv('./low_hazard_tone.csv',index=False)

# Generate high hazard tones
high_h_tones = genTrials(200,.9,.9)
high_h_tones.to_csv('./high_hazard_tone.csv',index=False)
