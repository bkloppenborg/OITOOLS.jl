#
# BOOTSTRAP EXAMPLE
#

include("oitools.jl");
oifitsfile = "AlphaCenA.oifits";
data = (readoifits(oifitsfile))[1,1];
params,params_err = bootstrap_v2_fit(1000, data, visibility_ud, [8.0]);
params,params_err = bootstrap_v2_fit(1000, data, visibility_ldquad, [1.0,0.1,0.]);
