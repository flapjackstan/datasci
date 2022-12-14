# -*- coding: utf-8 -*-
"""
Created on Thu Oct 20 10:18:18 2022

@author: elmsc
"""
#%%

import geopandas as gpd
import pandas as pd


#%%

def xy_to_points(df, longitude_string, latitude_string):
    """

    Parameters
    ----------
    df : pandas df
        dataframe with x and y

    Returns
    -------
    points : geopandas gdf
        Geodataframe with points
        
    References
    -------
    https://geopandas.org/en/stable/gallery/create_geopandas_from_pandas.html
    
    Todo
    -------
    

    """
    points = gpd.GeoDataFrame(df, geometry=gpd.points_from_xy(df[longitude_string], df[latitude_string]))
    points = points.set_crs('epsg:3857')
    return points

#%%

airbnb = pd.read_csv("../data/airbnb.csv")

airbnb_points = xy_to_points(airbnb, "longitude", "latitude")

airbnb_points.to_file("airbnb_points.geojson", driver="GeoJSON")