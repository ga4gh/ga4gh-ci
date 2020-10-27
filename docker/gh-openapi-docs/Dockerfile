FROM node:15.0.1

WORKDIR /usr/src

COPY scripts scripts
RUN chmod 755 scripts/*

RUN npm install -g @redocly/openapi-cli
RUN npm install -g redoc-cli
RUN npm install -g @ga4gh/gh-openapi-docs

WORKDIR /usr/src/repo

CMD ["bash", "../scripts/run.sh"]
