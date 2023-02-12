FROM ducksauz/esp-matter-dev

ARG DEBIAN_FRONTEND=nointeractive

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV PATH=/opt/qemu/bin:${PATH}

RUN touch /opt/espressif/matter-workshop.flag

# ENTRYPOINT [ "/opt/esp/entrypoint.sh" ]

CMD ["/bin/bash"]