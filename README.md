# Tajinaste Database

Database service for [Tajinaste Manager](https://github.com/pedroetb/tajinaste-manager).

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Sponsor](https://img.shields.io/badge/-Sponsor-fafbfc?logo=GitHub%20Sponsors)](https://github.com/sponsors/pedroetb)

## Variables

### Preset variables

These variables already have a default value set, but you can overwrite it in your environment before running the service:

* **POSTGRES_DB**: PostgreSQL database name (default: `tajinaste`).
* **POSTGRES_USER**: PostgreSQL database default user (default: `postgres`).

### Secret variables

You must set these variables in your environment before running the service:

* **POSTGRES_PASSWORD**: PostgreSQL database password for user *POSTGRES_USER* (default: `changeme`).

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

This project is released under the [MIT License](LICENSE).
