FROM quay.io/dit4c/dit4c-container-ipython:fakeroot
MAINTAINER Tim Dettrick <t.dettrick@uq.edu.au>

# Install Octave
RUN rpm --rebuilddb && fsudo yum install -y ghostscript octave && \
  source /opt/python/bin/activate && \
  export IPYTHONDIR=/opt/ipython && \
  pip install git+https://github.com/Calysto/metakernel.git#egg=metakernel && \
  pip install octave_kernel

# Install Julia
RUN cd /tmp && \
  curl -L https://status.julialang.org/download/linux-x86_64 | tar xzv && \
  cd julia* && \
  rsync -avv ./ /usr/local/ && \
  cd - && rm -r julia*
RUN fsudo yum install -y nettle
RUN source /opt/python/bin/activate && \
  IPYTHONDIR=/opt/ipython julia -e 'Pkg.init(); Pkg.add("IJulia")'

COPY /var /var

# Because COPY doesn't respect USER...
USER root
RUN chown -R researcher:researcher /var
USER researcher
