FROM centos:6

RUN yum update -y
RUN yum install -y rsync
RUN yum install -y git
RUN yum install -y centos-release-SCL
RUN yum install -y devtoolset-7-gcc*
RUN yum install -y python27
RUN yum install -y zlib-devel
RUN source scl_source enable python27; \
    easy_install pip; \
    pip install --upgrade pip

RUN git clone -q --recursive -- git://github.com/python/cpython.git /cpython

ADD komodo /komodo
WORKDIR /komodo

RUN cp python-mk.sh examples
RUN source scl_source enable python27; \
    pip install -r requirements.txt; \
    ./setup.py install

WORKDIR /komodo/examples
RUN source scl_source enable python27; \
    source scl_source enable devtoolset-7; \
    kmd releases/unstable.yml --prefix dist --release unstable --jobs 10 repository.yml --renamer mv 1>&2

CMD ["bash"]
