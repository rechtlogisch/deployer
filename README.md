# PHP with Deployer and Composer

[![GitHub Workflow actions](https://github.com/rechtlogisch/deployer/workflows/Build%20and%20publish%20Docker%20images/badge.svg)](https://github.com/rechtlogisch/deployer/actions)
[![Tags](https://ghcr-badge.egpl.dev/rechtlogisch/deployer/tags)](https://github.com/rechtlogisch/deployer/pkgs/container/deployer)
[![Size](https://ghcr-badge.egpl.dev/rechtlogisch/deployer/size?tag=latest)](https://github.com/rechtlogisch/deployer/pkgs/container/deployer)

A custom image for CI Pipelines to install dependencies, run tests and deploy code to remote servers.  

Based on the currently supported stable PHP CLI Alpine ([cli-alpine](https://github.com/docker-library/docs/blob/master/php/README.md#supported-tags-and-respective-dockerfile-links)).

Features:
- PHP 8.4-rc / PHP 8.3 / PHP 8.2 / PHP 8.1 (based on [tags](https://hub.docker.com/repository/docker/rechtlogisch/deployer/tags))
- [Composer 2](https://getcomposer.org/)
- [Deployer 7](https://deployer.org/)
- Very small size

This Dockerfile is automagically built with a [GitHub Workflow](https://github.com/rechtlogisch/deployer/actions/workflows/build-and-publish.yml). A separately hosted script checks for the newest stable PHP versions at ~5am UTC every day and triggers builds, when a new official PHP docker image is available.

# Usage

Feel free to use `ghcr.io/rechtlogisch/deployer` or `rechtlogisch/deployer` with any Pipeline of your choice. You'll find usage examples in the [Wiki](https://github.com/rechtlogisch/deployer/wiki) for the following service providers:

* [Bitbucket](https://github.com/rechtlogisch/deployer/wiki/Bitbucket-Pipeline)
* [GitLab](https://github.com/rechtlogisch/deployer/wiki/GitLab-Pipeline)

## PHP modules included

* [List of PHP modules](https://github.com/rechtlogisch/deployer/wiki/List-of-PHP-modules)

## Known issues

* [Access private repositories with your Pipeline SSH Key](https://github.com/rechtlogisch/deployer/wiki/Access-private-repositories-with-your-Pipeline-SSH-Key)

## Contributing

Please see [CONTRIBUTING](https://github.com/rechtlogisch/deployer/blob/main/.github/CONTRIBUTING.md) for details.

## Security Vulnerabilities

Please review [our security policy](https://github.com/rechtlogisch/deployer/security/policy) on how to report security vulnerabilities.

## Credits

- [Krzysztof Tomasz Zembrowski](https://github.com/zembrowski)
- [All Contributors](https://github.com/rechtlogisch/deployer/graphs/contributors)

## License

The MIT License (MIT). Please see [License File](https://github.com/rechtlogisch/deployer/blob/main/LICENSE) for more information.
