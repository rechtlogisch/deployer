# PHP with Deployer and Composer

[![Docker Cloud automated build](https://img.shields.io/docker/cloud/automated/rechtlogisch/deployer)](https://hub.docker.com/r/rechtlogisch/deployer)
[![GitHub Workflow actions](https://github.com/rechtlogisch/deployer/workflows/Publish%20images/badge.svg)](https://github.com/rechtlogisch/deployer/actions)
[![Docker Cloud build status](https://img.shields.io/docker/cloud/build/rechtlogisch/deployer)](https://hub.docker.com/r/rechtlogisch/deployer/builds)
[![Docker image size :latest](https://img.shields.io/docker/image-size/rechtlogisch/deployer/latest)](https://hub.docker.com/r/rechtlogisch/deployer/tags)
[![Docker image layers :latest](https://img.shields.io/microbadger/layers/rechtlogisch/deployer)](https://hub.docker.com/r/rechtlogisch/deployer/tags)

A custom image for CI Pipelines to install dependencies, run tests and deploy code to remote servers.  

Based on the currently supported stable PHP CLI Alpine ([cli-alpine](https://github.com/docker-library/docs/blob/master/php/README.md#supported-tags-and-respective-dockerfile-links)).

Features:
- PHP 8 / PHP 7 (based on [tags](https://hub.docker.com/repository/docker/rechtlogisch/deployer/tags))
- Composer 2
- Deployer 7 (includes Recipes)
- Very small size

This Dockerfile is automagically built and pushed to [Docker Hub](https://hub.docker.com/r/rechtlogisch/deployer). Currently, only for the linux/amd64 platform. A separately hosted script checks for the newest stable PHP versions at ~5am UTC every day and triggers builds, when a new official PHP docker image is available.

# Usage

Feel free to use `rechtlogisch/deployer` with any Pipeline of your choice. You'll find usage examples in the [Wiki](../../wiki) for the following service providers:

* [Bitbucket](../../wiki/Bitbucket-Pipeline)
* [GitLab](../../wiki/GitLab-Pipeline)

## PHP modules included

* [List of PHP modules](../../wiki/List-of-PHP-modules)

## Known issues

* [Access private repositories with your Pipeline SSH Key](../../wiki/Access-private-repositories-with-your-Pipeline-SSH-Key)

## Changelog

Please see [Releases](../../releases) for more information on what has changed recently.

## Contributing

Please see [CONTRIBUTING](.github/CONTRIBUTING.md) for details.

## Security Vulnerabilities

Please review [our security policy](../../security/policy) on how to report security vulnerabilities.

## Credits

- [Krzysztof Tomasz Zembrowski](https://github.com/zembrowski)
- [All Contributors](../../contributors)

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
