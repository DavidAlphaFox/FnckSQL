FROM rust:1.75 as builder

ADD ./src ./builder/src
ADD ./Cargo.toml ./builder/Cargo.toml
ADD ./tests/sqllogictest ./builder/tests/sqllogictest

WORKDIR /builder

RUN rustup default nightly
RUN cargo build --release

FROM ubuntu

ARG APP_SERVER=fnck_sql

WORKDIR /fnck_sql

ENV IP="127.0.0.1"

EXPOSE 5432

COPY --from=builder /builder/target/release/${APP_SERVER} ${APP_SERVER}

ENTRYPOINT ["./fnck_sql"]