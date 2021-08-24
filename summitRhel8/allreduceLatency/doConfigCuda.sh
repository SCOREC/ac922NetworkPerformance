$1/configure --enable-cuda CXX=mpicxx CC=mpicc \
--prefix=$PWD/install \
--with-cuda-include=$CUDA_DIR/targets/ppc64le-linux/include \
--with-cuda-libpath=$CUDA_DIR/targets/ppc64le-linux/lib


