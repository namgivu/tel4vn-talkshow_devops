# Multi-stage Dockerfile for Vite + React production build served by Nginx

# ---------- Build stage ----------
# Why node:20-alpine?
# - Node 20 is a stable, widely-used LTS that works well with modern Vite/React toolchains.
# - Pinning to a major version (20) keeps builds reproducible while still getting security updates.
# - The alpine variant is small and fast to pull, making CI/CD quicker. Great for build stages.
# Caveats and alternatives:
# - Alpine uses musl libc. If you compile native deps that expect glibc, consider node:20-bookworm or node:20-bookworm-slim.
# - If you require a newer/older Node, change the tag (e.g., node:22-alpine) to match your toolchain.
FROM node:20-alpine AS build
WORKDIR /app

# Install deps first (better layer caching)
COPY ../package.json ../package-lock.json* ./
RUN set -eux; \
    if [ -f package-lock.json ]; then npm ci; \
    else                              npm  i; fi

# Copy the rest and build
COPY . .
RUN npm run build


# ---------- Runtime stage ----------
FROM nginx:1.27-alpine AS runtime

# Copy built assets to Nginx html directory
COPY --from=build /app/dist /usr/share/nginx/html

# Healthcheck to ensure Nginx is serving content
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -q -O - http://127.0.0.1/ >/dev/null 2>&1 || exit 1

# Expose the default Nginx port
EXPOSE 80

# Use the default Nginx startup command
CMD ["nginx", "-g", "daemon off;"]
