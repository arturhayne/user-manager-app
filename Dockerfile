FROM node:14-alpine3.15 AS BUILD_IMAGE

WORKDIR /app

COPY ["package.json", "yarn.lock", ".npmrc", "./"]

RUN apk add --no-cache python3 make g++

RUN yarn install

COPY . .

RUN yarn build

# remove unused dependencies
RUN rm -rf node_modules/rxjs/src/ node_modules/rxjs/bundles/ node_modules/rxjs/_esm5/ \
    && rm -rf node_modules/rxjs/_esm2015/ node_modules/swagger-ui-dist/*.map node_modules/couchbase/src/

FROM node:14-alpine3.15

WORKDIR /app

# copy from build image
COPY --from=BUILD_IMAGE /app/node_modules ./node_modules

EXPOSE 8081

CMD ["npm", "run", "serve:docker"]