#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


# In[4]:


df = pd.read_csv(r"C:\Users\USER\Desktop\Shopee  Test for Business Intelligence Role\Python\test_candidate_03.csv")


# In[7]:


df.info()


# In[8]:


clean_df = df.dropna()


# In[9]:


clean_df.info()


# In[10]:


clean_df.head(10)


# In[13]:


shop_gmv = clean_df.groupby('shop_id')['gmv_usd'].sum().reset_index()


# In[15]:


shop_gmv.head(11)


# In[16]:


shop_gmv_sorted = shop_gmv.sort_values(by='gmv_usd', ascending=False)


# In[17]:


shop_gmv_sorted


# In[18]:


Top_10_shops = shop_gmv_sorted.head(10)


# In[19]:


print(Top_10_shops)


# In[20]:


Top_10_shops


# In[ ]:




