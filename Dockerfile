# ===== Base image =====
FROM node:20-alpine AS base
WORKDIR /app

# ===== Dependencies =====
FROM base AS deps
RUN apk add --no-cache libc6-compat
COPY package.json package-lock.json* yarn.lock* pnpm-lock.yaml* ./
RUN \
  if [ -f yarn.lock ]; then yarn install --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then npm i -g pnpm && pnpm install; \
  else npm install; \
  fi

# ===== Builder =====
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# مهم: build production
RUN npm run build

# ===== Runner =====
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

# user أمان
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# نسخ الملفات اللازمة فقط
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

USER nextjs

EXPOSE 3000

CMD ["npm", "start"]
