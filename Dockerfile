FROM node:20-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
COPY . /app
WORKDIR /app

FROM base AS prod-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile

FROM base AS build-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

FROM build-deps AS build
COPY . .
RUN --mount=type=secret,id=strapi_url \
    --mount=type=secret,id=strapi_token \
    export STRAPI_URL=$(cat /run/secrets/strapi_url) && \
    export STRAPI_TOKEN=$(cat /run/secrets/strapi_token) && \
    pnpm run build

FROM base AS runtime
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

ENV HOST=0.0.0.0
ENV PORT=3000
EXPOSE 3000
CMD node ./dist/server/entry.mjs