# Example to load one of NPOI files with multiple targets
include("oitools.jl");

filename = "HD48329_oidata.fits";
targetname =  "FKV0254";
data = (readoifits_filter(filename, targetname=targetname, filter_bad_data = true))[1,1];
v2plot(data,logplot=true);# Alternatively, one can do v2plot(data.v2_baseline,data.v2,data.v2_err,logplot=true);

f_chi2, params, cvis_model = fit_model_v2(data, visibility_ud, [1.0]);# diameter is the parameter
