FROM debian
RUN apt-get update && apt-get install -y git wget flex bison gperf python python-pip python-setuptools cmake ninja-build ccache libffi-dev libssl-dev dfu-util
RUN apt-get install -y python3 python3-pip python3-setuptools
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
WORKDIR /esp
ENV HOME /esp
RUN git clone --recursive https://github.com/espressif/esp-idf.git
WORKDIR /esp/esp-idf 
RUN /esp/esp-idf/install.sh
WORKDIR /workspace
