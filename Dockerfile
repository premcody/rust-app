# ── Stage 1: Build ──────────────────────────────────────────────────────────
# Uses the official Rust image only for compiling. This layer is discarded
# in the final image — no Rust toolchain ships to production.
FROM docker.io/library/rust:1.76-slim AS builder

WORKDIR /app

# Copy dependency manifest first so Docker can cache the dep-fetch layer.
# If only src/ changes, cargo fetch is skipped on rebuild.
COPY Cargo.toml ./
RUN mkdir src && echo "fn main() {}" > src/main.rs && cargo fetch

# Now copy real source and build the release binary
COPY src ./src
RUN cargo build --release

# ── Stage 2: Runtime ─────────────────────────────────────────────────────────
# Red Hat UBI9 Micro — minimal Red Hat base, no package manager, no shell.
# Only our compiled binary goes in. Final image is ~15MB vs ~1.5GB for the builder.
FROM registry.access.redhat.com/ubi9/ubi-micro

# Copy only the compiled binary from the build stage
COPY --from=builder /app/target/release/rust-app /usr/local/bin/rust-app

CMD ["/usr/local/bin/rust-app"]
