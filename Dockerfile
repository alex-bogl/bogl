# --- Stage 1: Build the Haskell binary ---
FROM haskell:9.6.5 AS builder

ENV STACK_ROOT=/root/.stack \
    PATH=/root/.local/bin:$PATH

WORKDIR /app
COPY . .

RUN stack setup && \
    stack build --only-dependencies && \
    stack build --copy-bins

# --- Stage 2: Run the server ---
FROM debian:bookworm-slim
WORKDIR /app
COPY --from=builder /root/.local/bin/boglserver /app/
EXPOSE 8080
CMD ["./boglserver"]
