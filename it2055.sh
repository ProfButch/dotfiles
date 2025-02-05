# ----------------------------------
# Docker Anaconda
# https://hub.docker.com/r/continuumio/anaconda3
# ----------------------------------


alias dkr_jupyter="docker run -i -t -p 8888:8888 continuumio/anaconda3 /bin/bash -c \"\
    conda install jupyter -y --quiet && \
    mkdir -p /opt/notebooks && \
    jupyter notebook \
    --notebook-dir=/opt/notebooks --ip='*' --port=8888 \
    --no-browser --allow-root\"";

alias dkr_conda='docker run -i -t continuumio/anaconda3 /bin/bash'