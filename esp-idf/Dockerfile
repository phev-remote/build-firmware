FROM debian
RUN apt update && apt-get -y install git wget flex bison gperf python python-pip python-setuptools cmake ninja-build ccache libffi-dev libssl-dev
WORKDIR /esp
ENV HOME /esp
RUN git clone --recursive https://github.com/espressif/esp-idf.git
RUN cd esp-idf && ./install.sh
RUN chmod +x /esp/esp-idf/export.sh
RUN echo ". $HOME/esp/esp-idf/export.sh" >> $HOME/.bash_profile
ENV IDF_PATH $HOME/esp-idf
ENV PATH $IDF_PATH/tools:$HOME/.espressif/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin:$PATH:/esp/.espressif/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin
WORKDIR /workspace
CMD [ "idf.py" ]
