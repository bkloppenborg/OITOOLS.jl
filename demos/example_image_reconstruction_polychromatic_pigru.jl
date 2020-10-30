#
# Image reconstruction code with spectral regularization
# This requires a private example file at the moment
#
using OITOOLS, HDF5
oifitsfile= "./data/pigru.oifits"
data = vec(readoifits(oifitsfile, polychromatic = true, filter_bad_data=true, force_full_t3=true, use_vis=false)) ;
# for i=1:length(data)
#     data[i].t3amp_err .+= 5e-7 # some t3amp errors are underestimated
# end
nwavs = length(data)
nx = 64 #number of pixels (side)
pixsize = 0.45 # mas/pixel

ft = setup_nfft_polychromatic(data, nx, pixsize);
nwavs = length(ft)

# Setup regularization
regularizers = [   [ ["centering", 1e5], ["tv", 1e3] ]]  # Frame 1 is centered
for i=1:nwavs-1
    push!(regularizers,[["centering", 1e5], ["tv",1e3]]) # Total variation for all
end
push!(regularizers,[ ["transspectral_structnorm", 1.0], ["transspectral_tvsq", 20.0] ]); #transspectral regularization ties the frames together

x_start = gaussian2d(nx,nx,nx/6);
x_start /= sum(x_start);
x_start = repeat(vec(x_start), nwavs)
#x_start = repeat(vec(rand(nx, nx)), nwavs);
x = vec(x_start)
for i=1:25
global x = reconstruct_polychromatic(x, data, ft, regularizers = regularizers, weights=[1.0,0.0,1.0], maxiter = 2000, verb = false);
imdisp_polychromatic(reshape(x,nx*nx,nwavs), pixscale=pixsize)
end