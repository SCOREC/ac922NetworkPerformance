./configure --enable-cuda CXX=mpicxx CC=mpicc \
--prefix=$PWD/xl161-cuda100-spectrum-install \
--with-cuda-include=$CUDA_PATH/include \
--with-cuda-libpath=$CUDA_PATH/lib64

