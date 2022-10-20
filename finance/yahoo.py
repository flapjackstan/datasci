#%%
import pandas_datareader as pdr
import datetime as dt
import os

#%%

os.chdir('C:/Users/elmsc/Documents/Code/datasci/finance')

#%%

def getData(stocks, start, end):
    data = pdr.get_data_yahoo(stocks, start, end, interval='m')
    data = data['Adj Close']
    return data

#%%
ticker_list = ["ORCL", "GIS", "COP"]
#stocks = [stock+'.AX' for stock in ticker_list]

start = dt.datetime(2017, 1, 1)
end = dt.datetime(2022, 1, 1)


data = pdr.get_data_yahoo(ticker_list, start, end, interval='m')


#%%

data = getData(ticker_list, start, end)

#%%

og_cols = data.columns
rename_cols = [i + '-adj_close' for i in og_cols]

#%%

data.columns = rename_cols

#%%


#%%

data.to_csv('yahoo.csv')


