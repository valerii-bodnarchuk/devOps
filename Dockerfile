FROM node:20-alpine AS deps
WORKDIR /app
COPY app/package.json app/package-lock.json* ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev --omit=optional

FROM node:20-alpine AS builder
WORKDIR /app
COPY app/ ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci && npm run build

FROM node:20-alpine AS runner
WORKDIR /app

ARG NODE_ENV=production
ENV NODE_ENV=$NODE_ENV
LABEL org.opencontainers.image.source="https://github.com/valeriibodnarchuk/val-api" \
      org.opencontainers.image.description="Val API service" \
      org.opencontainers.image.licenses="MIT"

COPY --from=deps    --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/dist         ./dist

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health >/dev/null || exit 1

EXPOSE 3000
USER node
CMD ["node", "dist/index.js"]
