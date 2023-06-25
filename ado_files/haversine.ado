
*! version 0.1.0 Hall 25jun2023
cap program drop haversine
program define haversine
    // accept a varlist of 4 variables
    syntax varlist(min=4 max=4) [if] [in], [Gen(string)] Replace

    local lat1 : word 1 of `varlist'
    local lon1 : word 2 of `varlist'
    local lat2 : word 3 of `varlist'
    local lon2 : word 4 of `varlist'

    if "`gen'" == "" {
        local gen _haversine_distance
    }

    local _haversine_pi 3.14159265358979323846
    local _haversine_rad 6371.0088

    qui gen _lat_i_rad = `lat1' * (`_haversine_pi'/180) `if' `in'
    qui gen _lon_i_rad = `lon1' * (`_haversine_pi'/180) `if' `in'
    qui gen _lat_j_rad = `lat2' * (`_haversine_pi'/180) `if' `in'
    qui gen _lon_j_rad = `lon2' * (`_haversine_pi'/180) `if' `in'
    qui gen _dlat = _lat_j_rad - _lat_i_rad `if' `in'
    qui gen _dlon = _lon_j_rad - _lon_i_rad `if' `in'
    qui gen _haversin_inter = ///
        sin(_dlat/2)^2 ///
        + cos(_lat_i_rad) * cos(_lat_j_rad) * sin(_dlon/2)^2 `if' `in'
    qui gen _haversin_inter2 = ///
        2 * atan(sqrt(_haversin_inter)/sqrt(1-_haversin_inter)) `if' `in'
    
    if "`replace'" != "" {
        cap drop `gen'
    }
    qui gen `gen' = `_haversine_rad' * _haversin_inter2 `if' `in'

    qui drop _lat_i_rad _lon_i_rad _lat_j_rad _lon_j_rad ///
        _dlat _dlon _haversin_inter _haversin_inter2

    label var `gen' "Haversine Formula - Distance in km"

end