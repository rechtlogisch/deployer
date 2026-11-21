# PHP with Deployer

[![GitHub Workflow actions](https://github.com/rechtlogisch/deployer/actions/workflows/build-and-publish.yml/badge.svg)](https://github.com/rechtlogisch/deployer/actions)
[![Size](https://img.shields.io/docker/image-size/rechtlogisch/deployer/latest)](https://github.com/rechtlogisch/deployer/pkgs/container/deployer)
[![Tags](https://ghcr-badge.egpl.dev/rechtlogisch/deployer/tags)](https://github.com/rechtlogisch/deployer/pkgs/container/deployer)

A custom image for CI Pipelines to run tests and deploy code to remote servers with [Deployer](https://deployer.org/).

Based on the currently supported stable PHP CLI Alpine ([cli-alpine](https://github.com/docker-library/docs/blob/master/php/README.md#supported-tags-and-respective-dockerfile-links)).

Features:
- PHP 8.6 / PHP 8.5 / PHP 8.4 / PHP 8.3 / PHP 8.2 (based on [tags](https://hub.docker.com/repository/docker/rechtlogisch/deployer/tags))
- [Deployer 8](https://deployer.org/) (`dep`)
- OpenSSH client (`ssh`, `ssh-agent`, `ssh-add`, `ssh-keyscan`, `scp`)
- Very small size

Composer is **not** included: Deployer's `deploy:vendors` runs Composer on the **remote** host (and downloads it there if missing). Install project dependencies in a separate CI step or image if needed.

This is a pre-built image to be used directly in pipelines, not a base for other images. To keep it small, it contains only what is needed to run PHP and Deployer. PHP sources and headers, `docker-php-ext-*`, `pecl`, `pear`, `phpize`, `php-cgi` and `phpdbg` of the official image are not included, and `apk` is removed, so packages or PHP extensions cannot be installed on top of it. If you need them, use a multi-stage build based on the [official PHP image](https://hub.docker.com/_/php) instead.

This Dockerfile is automagically built with a [GitHub Workflow](https://github.com/rechtlogisch/deployer/actions/workflows/build-and-publish.yml). A separately hosted script checks for the newest stable PHP versions at ~5am UTC every day and triggers builds, when a new official PHP docker image is available.

# Usage

Feel free to use `ghcr.io/rechtlogisch/deployer` or `rechtlogisch/deployer` with any Pipeline of your choice. You'll find usage examples in the [Wiki](https://github.com/rechtlogisch/deployer/wiki) for the following service providers:

* [Bitbucket](https://github.com/rechtlogisch/deployer/wiki/Bitbucket-Pipeline)
* [GitLab](https://github.com/rechtlogisch/deployer/wiki/GitLab-Pipeline)

## PHP modules included

* [List of PHP modules](https://github.com/rechtlogisch/deployer/wiki/List-of-PHP-modules)

## Known issues

* [Access private repositories with your Pipeline SSH Key](https://github.com/rechtlogisch/deployer/wiki/Access-private-repositories-with-your-Pipeline-SSH-Key)

## Supply-chain attestations

The `unknown/unknown` entries shown for a tag on GHCR are BuildKit provenance (`provenance: mode=max`) and SBOM attestation manifests (enabled in [e0618b5](https://github.com/rechtlogisch/deployer/commit/e0618b5)), not runnable images. `docker pull` ignores them. This is expected because GHCR does not support OCI referrers yet ([docker/buildx#3047](https://github.com/docker/buildx/issues/3047)).

Inspect them with:

```bash
docker buildx imagetools inspect ghcr.io/rechtlogisch/deployer:latest --format '{{json .Provenance}}'
docker buildx imagetools inspect ghcr.io/rechtlogisch/deployer:latest --format '{{json .SBOM}}'
```

## Contributing

Please see [CONTRIBUTING](https://github.com/rechtlogisch/deployer/blob/main/.github/CONTRIBUTING.md) for details.

## Security Vulnerabilities

Please review [our security policy](https://github.com/rechtlogisch/deployer/security/policy) on how to report security vulnerabilities.

## Credits

- [Krzysztof Tomasz Zembrowski](https://github.com/zembrowski)
- [All Contributors](https://github.com/rechtlogisch/deployer/graphs/contributors)

## License

The MIT License (MIT). Please see [License File](https://github.com/rechtlogisch/deployer/blob/main/LICENSE) for more information.
