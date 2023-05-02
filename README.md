# PHP with Deployer and Composer

[![GitHub Workflow actions](https://github.com/rechtlogisch/deployer/workflows/Build%20and%20publish%20Docker%20images/badge.svg)](https://github.com/rechtlogisch/deployer/actions)
[![Tags](https://ghcr-badge.deta.dev/rechtlogisch/deployer/tags)](https://github.com/rechtlogisch/deployer/pkgs/container/deployer)
[![Size](https://ghcr-badge.deta.dev/rechtlogisch/deployer/size?tag=latest)](https://github.com/rechtlogisch/deployer/pkgs/container/deployer)

A custom image for CI Pipelines to install dependencies, run tests and deploy code to remote servers.  

Based on the currently supported stable PHP CLI Alpine ([cli-alpine](https://github.com/docker-library/docs/blob/master/php/README.md#supported-tags-and-respective-dockerfile-links)).

Features:
- PHP 8.2 / PHP 8.1 / PHP 8.0 (based on [tags](https://hub.docker.com/repository/docker/rechtlogisch/deployer/tags))
- [Composer 2](https://getcomposer.org/)
- [Deployer 7](https://deployer.org/)
- Very small size

This Dockerfile is automagically built with a [GitHub Workflow](.github/workflows/build-and-publish.yml). Currently, only for the linux/amd64 platform. A separately hosted script checks for the newest stable PHP versions at ~5am UTC every day and triggers builds, when a new official PHP docker image is available.

# Usage

Feel free to use `ghcr.io/rechtlogisch/deployer` or `rechtlogisch/deployer` with any Pipeline of your choice. You'll find usage examples in the [Wiki](../../wiki) for the following service providers:

* [Bitbucket](../../wiki/Bitbucket-Pipeline)
* [GitLab](../../wiki/GitLab-Pipeline)

## PHP modules included

* [List of PHP modules](../../wiki/List-of-PHP-modules)

## Known issues

* [Access private repositories with your Pipeline SSH Key](../../wiki/Access-private-repositories-with-your-Pipeline-SSH-Key)

## Contributing

Please see [CONTRIBUTING](.github/CONTRIBUTING.md) for details.

## Security Vulnerabilities

Please review [our security policy](../../security/policy) on how to report security vulnerabilities.

## Credits

- [Krzysztof Tomasz Zembrowski](https://github.com/zembrowski)
- [All Contributors](../../contributors)

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
