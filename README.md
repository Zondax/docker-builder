# Docker Containers

This repository includes the following containers:

| Name                 | Description                      | To build run:         |
| -------------------- | -------------------------------- | --------------------- |
| zondax/builder-base  | Base configuration               | `make build_base`     |
| zondax/builder-yocto | Yocto                            | `make build_yocto`    |
| zondax/builder-bolos | Bolos - builder                  | `make build_bolos`    |
| zondax/builder-zemu  | Zemu (Ledger emulation)          | `make build_zemu`     |
| zondax/circleci      | CircleCI - C++ projects tooling  | `make build_circleci` |
| zondax/rust-ci       | CircleCI - Rust projects tooling | `make build_rustci`   |

Containers are all published in Dockerhub
