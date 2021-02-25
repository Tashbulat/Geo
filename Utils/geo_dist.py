# function calculates geo greate circle distance for pandas dataframe

def f_dist(df, col_lat_1, col_lon_1, col_lat_2, col_lon_2, col_dist):
    lat_1 = math.pi / 180 * df[col_lat_1].to_numpy()
    lon_1 = math.pi / 180 * df[col_lon_1].to_numpy()
    lat_2 = math.pi / 180 * df[col_lat_2].to_numpy()
    lon_2 = math.pi / 180 * df[col_lon_2].to_numpy()

    dlon = lon_1 - lon_2
    dlat = lat_1 - lat_2
    a = np.sin(dlat / 2) ** 2 + np.cos(lat_1) * np.cos(lat_2) * np.sin(dlon / 2) ** 2
    c = 2 * np.arcsin(np.sqrt(a))
    dist = c * 6371.009

    df[col_dist] = dist

    return df