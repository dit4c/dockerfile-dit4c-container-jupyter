FROM dit4c/dit4c-container-ipython:latest
MAINTAINER Tim Dettrick <t.dettrick@uq.edu.au>

# Install Octave
RUN yum install -y ghostscript octave && \
    source /opt/python/bin/activate && \
    export IPYTHONDIR=/opt/ipython && \
    pip install git+https://github.com/Calysto/metakernel.git#egg=metakernel && \
    pip install octave_kernel

# Install Julia
RUN cd /etc/yum.repos.d && \
    wget https://copr.fedoraproject.org/coprs/nalimilan/julia/repo/epel-7/nalimilan-julia-epel-7.repo && \
    cd - && \
    yum install -y julia nettle && \
    mkdir -p /opt/julia && \
    source /opt/python/bin/activate && \
    IPYTHONDIR=/opt/ipython JULIA_PKGDIR=/opt/julia julia -e 'Pkg.init(); Pkg.add("IJulia")' && \
    chown -R researcher /opt/python /opt/ipython
