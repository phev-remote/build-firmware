FROM papawattu/build-firmware
RUN apt-get install -y jq
ADD client_loop.sh /scripts/
ENV IDF_PATH /esp/esp-idf
CMD ["bash","/scripts/client_loop.sh"]
